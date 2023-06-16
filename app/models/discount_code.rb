# frozen_string_literal: true

class PromotionCode < ApplicationRecord
  validates :code, presence: true, uniqueness: true

  has_many :orders, dependent: :nullify
end
