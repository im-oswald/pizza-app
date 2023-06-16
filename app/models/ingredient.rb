# frozen_string_literal: true

class Ingredient < ApplicationRecord
  has_many :add_item_ingredients, dependent: :destroy
  has_many :remove_item_ingredients, dependent: :destroy
  has_many :add_items, through: :add_item_ingredients, source: :item
  has_many :remove_items, through: :remove_item_ingredients, source: :item
  has_many :orders, through: :items

  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
end
