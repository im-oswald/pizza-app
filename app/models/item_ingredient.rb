# frozen_string_literal: true

class RemoveItemIngredient < ApplicationRecord
  belongs_to :item
  belongs_to :ingredient, polymorphic: true
end
