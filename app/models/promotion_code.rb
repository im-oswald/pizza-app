# frozen_string_literal: true

class PromotionCode < ApplicationRecord
  validates :code, presence: true, uniqueness: true

  has_and_belongs_to_many :orders, join_table: :orders_promotion_codes
end
