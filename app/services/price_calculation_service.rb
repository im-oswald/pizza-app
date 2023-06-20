# frozen_string_literal: true

class PriceCalculationException < StandardError
end

class PriceCalculationService
  def initialize(order)
    @order = order
    @pricing_rules = PricingRules.load_rules
  end

  def self.call(order)
    new(order).call
  end

  def call
    calculate_price
  rescue StandardError => e
    raise PriceCalculationException, "Error calculating order: #{e.message}"
  end

  private

  def calculate_price
    # calcualte the total price of the order
    total = calculate_total_price
    Rails.logger.debug { "Order##{@order.uuid} total: #{total}" }

    # apply promocodes if order has them
    total = apply_promotions(total) if @order.promotion_codes.any?
    Rails.logger.debug { "Order##{@order.uuid} total after applying promo codes: #{total}" }

    # apply discount if order has one
    total = apply_discount(total) if @order.discount_code.present?
    Rails.logger.debug { "Order##{@order.uuid} total after applying discount: #{total}" }

    total
  end

  def calculate_total_price
    @order.items.reload.sum { |item| calculate_item_price(item) + calculate_item_ingredients_price(item) }
  end

  def calculate_item_price(item)
    base_price(item) * size_multiplier(item)
  end

  def calculate_item_ingredients_price(item)
    calculate_ingredients_price(item) * size_multiplier(item)
  end

  def calculate_ingredients_price(item)
    item.add_ingredients.sum { |ingredient| ingredient_price(ingredient) } || 0
  end

  def base_price(item)
    @pricing_rules.dig('pizzas', item.name) || 1
  end

  def ingredient_price(ingredient)
    @pricing_rules.dig('ingredients', ingredient.name) || 0
  end

  def size_multiplier(item)
    @pricing_rules.dig('size_multipliers', item.size.capitalize) || 1
  end

  def apply_discount(price)
    price - (discount_percent / 100.0 * price).round(2)
  end

  def discount_percent
    @pricing_rules.dig('discounts', @order.discount_code&.code, 'deduction_in_percent') || 0
  end

  def apply_promotions(price)
    price - @order.promotion_codes.sum { |promotion_code| apply_promo_code(promotion_code.code) }
  end

  def apply_promo_code(promo_code)
    promotion = @pricing_rules.dig('promotions', promo_code)
    # No effect on price if promotion code is not found in the configuration
    # or any of the useful information is missing
    return 0 unless promotion && valid_promotion?(promotion)

    target_pizza = find_target_pizza(promotion)
    return 0 unless target_pizza # No effect on price if target pizza is not found in the order

    target_pizza_quantity = find_target_pizza_quantity_in_order(target_pizza)
    # A simple trick to handle the infinity is min
    applicable_quantity = [target_pizza_quantity / promotion['from'], target_pizza_quantity].min
    reduction_quantity = applicable_quantity * (promotion['from'] - promotion['to'])

    (reduction_quantity * calculate_item_price(target_pizza)) || 0
  end

  def valid_promotion?(promotion)
    promotion['target'] && promotion['target_size'] && promotion['from'] && promotion['to']
  end

  def find_target_pizza(promotion)
    @order.items.find { |item| item.name == promotion['target'] && item.size == promotion['target_size'].downcase }
  end

  def find_target_pizza_quantity_in_order(target_pizza)
    # This is order item and we could have many order items with same name and size for an order
    @order.items.count { |item| item.name == target_pizza.name && item.size == target_pizza.size }
  end
end
