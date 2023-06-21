# frozen_string_literal: true

class PromotionCode < ApplicationRecord
  validates :code, presence: true, uniqueness: true

  has_and_belongs_to_many :orders, join_table: :order_promotion_codes
end
