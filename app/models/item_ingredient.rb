# frozen_string_literal: true

class ItemIngredient < ApplicationRecord
  enum ingredient_type: { add_ingredient: 'AddIngredient', remove_ingredient: 'RemoveIngredient' }

  validates :ingredient_type, presence: true, inclusion: { in: ingredient_types.keys }

  belongs_to :item
  belongs_to :ingredient

  scope :add_ingredients, -> { where(ingredient_type: ingredient_types[:add_ingredient]) }
  scope :remove_ingredients, -> { where(ingredient_type: ingredient_types[:remove_ingredient]) }
end
