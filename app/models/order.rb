# frozen_string_literal: true

class Order < ApplicationRecord
  enum status: {
    completed: 'completed',
    open: 'open'
  }

  has_many :items, dependent: :destroy, after_remove: :calculate_total_price
  has_and_belongs_to_many :promotion_codes, join_table: :order_promotion_codes, after_remove: :calculate_total_price
  belongs_to :discount_code, optional: true

  before_save :calculate_total_price

  scope :active, lambda {
                   includes(:promotion_codes, :discount_code, items: %i[add_ingredients remove_ingredients item_ingredients])
                     .where(status: statuses[:open])
                 }

  def computed_price
    PriceCalculationService.call(self)
  end

  private

  # optional param for having the call from association callbacks
  # like order.items.destroy(item)
  def calculate_total_price(record = nil)
    # TBD: If we want to keep the price column on table entry then we can have this callback
    # self.price = computed_price
  end
end
