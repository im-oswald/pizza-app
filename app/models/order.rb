# frozen_string_literal: true

class Order < ApplicationRecord
  enum status: {
    completed: 'completed',
    open: 'open'
  }

  validates :status, presence: true, inclusion: { in: statuses.keys }

  has_many :items, dependent: :destroy
  has_and_belongs_to_many :promotion_codes, join_table: :orders_promotion_codes
  belongs_to :discount_code, optional: true
end
