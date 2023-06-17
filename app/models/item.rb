# frozen_string_literal: true

class Item < ApplicationRecord
  enum size: {
    small: 'small',
    medium: 'medium',
    large: 'large'
  }

  validates :name, presence: true, length: { maximum: 50 }
  validates :size, presence: true, inclusion: { in: sizes.keys }

  belongs_to :order
  has_many :item_ingredients, dependent: :destroy
  has_many :add_ingredients, -> { ItemIngredient.add_ingredients }, through: :item_ingredients, source: :ingredient
  has_many :remove_ingredients, -> { ItemIngredient.remove_ingredients }, through: :item_ingredients, source: :ingredient
end
