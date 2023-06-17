# frozen_string_literal: true

class Order < ApplicationRecord
  enum status: {
    completed: 'completed',
    open: 'open'
  }

  validates :status, presence: true, inclusion: { in: statuses.keys }

  has_many :items, dependent: :destroy
  has_and_belongs_to_many :promotion_codes, join_table: :order_promotion_codes
  belongs_to :discount_code, optional: true

  scope :active, lambda {
                   includes(:promotion_codes, :discount_code, items: %i[add_ingredients remove_ingredients]).where(status: statuses[:open])
                 }
end
