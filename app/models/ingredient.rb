# frozen_string_literal: true

class Ingredient < ApplicationRecord
  has_many :item_ingredients, dependent: :destroy
  has_many :items, through: :item_ingredients

  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
end
