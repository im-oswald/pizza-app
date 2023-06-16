# frozen_string_literal: true

class Item < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }

  enum size: {
    small: 'small',
    medium: 'medium',
    large: 'large'
  }

  belongs_to :order
  has_many :item_ingredients, dependent: :destroy
  has_many :add_ingredients, through: :item_ingredients, source: :ingredient, source_type: 'AddIngredient'
  has_many :remove_ingredients, through: :item_ingredients, source: :ingredient, source_type: 'RemoveIngredient'
end
