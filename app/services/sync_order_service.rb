# frozen_string_literal: true

class SyncOrderException < StandardError
end

class SyncOrderService
  def initialize(data)
    @data = data
  end

  def self.call(data)
    new(data).call
  end

  def call
    Order.transaction do
      @data.each do |raw_order|
        next if Order.find_by(uuid: raw_order['id']).present?

        create_data_from_raw(raw_order)
      end
    end
  rescue StandardError => e
    raise SyncOrderException, "Error seeding orders: #{e.message}"
  end

  private

  def create_data_from_raw(raw_order)
    order = create_order(raw_order)

    create_items(raw_order['items'], order)

    create_promotion_codes(raw_order['promotionCodes'], order)

    create_discount_code(raw_order['discountCode'], order)

    order.save!
  end

  def create_order(raw_order)
    Order.create!(
      uuid: raw_order['id'],
      status: raw_order['state']&.downcase,
      created_at: raw_order['createdAt']
    )
  end

  def create_items(raw_items, order)
    raw_items&.each do |raw_item|
      item = Item.find_or_create_by!(
        name: raw_item['name'],
        order:,
        size: raw_item['size']&.downcase
      )

      create_item_ingredients(raw_item['add'], item, :add_ingredient)
      create_item_ingredients(raw_item['remove'], item, :remove_ingredient)
    end
  end

  def create_item_ingredients(raw_ingredients, item, ingredient_type)
    return unless raw_ingredients&.any?

    raw_ingredients.each do |raw_ingredient|
      ItemIngredient.create!(ingredient: find_or_create_ingredient(raw_ingredient), item:, ingredient_type:)
    end
  end

  def create_promotion_codes(raw_promotion_codes, order)
    return unless raw_promotion_codes&.any?

    raw_promotion_codes.each do |raw_promotion_code|
      order.promotion_codes.push(find_or_create_promotion_code(raw_promotion_code))
    end
  end

  def create_discount_code(raw_discount_code, order)
    return if raw_discount_code.blank?

    order.discount_code = DiscountCode.find_or_create_by!(code: raw_discount_code)
  end

  def find_or_create_ingredient(name)
    Ingredient.find_or_create_by!(name:)
  end

  def find_or_create_promotion_code(code)
    PromotionCode.find_or_create_by!(code:)
  end
end
