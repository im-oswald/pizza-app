# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ItemIngredient, type: :model do
  describe 'associations' do
    it { should belong_to(:item) }
    it { should belong_to(:ingredient) }
  end

  describe 'scopes' do
    it 'returns item ingredients for adding ingredients' do
      add_ingredient = create(:item_ingredient, :add_ingredient)
      remove_ingredient = create(:item_ingredient, :remove_ingredient)

      expect(ItemIngredient.add_ingredients).to include(add_ingredient)
      expect(ItemIngredient.add_ingredients).not_to include(remove_ingredient)
    end

    it 'returns item ingredients for removing ingredients' do
      add_ingredient = create(:item_ingredient, :add_ingredient)
      remove_ingredient = create(:item_ingredient, :remove_ingredient)

      expect(ItemIngredient.remove_ingredients).to include(remove_ingredient)
      expect(ItemIngredient.remove_ingredients).not_to include(add_ingredient)
    end
  end
end
