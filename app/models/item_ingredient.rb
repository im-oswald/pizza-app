# frozen_string_literal: true

class ItemIngredient < ApplicationRecord
  enum ingredient_type: { add_ingredient: 'AddIngredient', remove_ingredient: 'RemoveIngredient' }

  belongs_to :item
  belongs_to :ingredient

  scope :add_ingredients, -> { where(ingredient_type: ingredient_types[:add_ingredient]) }
  scope :remove_ingredients, -> { where(ingredient_type: ingredient_types[:remove_ingredient]) }
end
