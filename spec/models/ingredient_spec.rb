require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(50) }

    context 'validates uniqueness of name' do
      let(:existing_ingredient) { create(:ingredient, name: 'Existing Ingredient') }
      let(:new_ingredient) { build(:ingredient, name: 'Existing Ingredient') }

      it 'should invalidate duplicate name' do
        expect(existing_ingredient).to be_valid

        expect(new_ingredient).not_to be_valid
        expect(new_ingredient.errors[:name]).to include('has already been taken')
      end
    end
  end

  describe "associations" do
    it { should have_many(:item_ingredients).dependent(:destroy) }
    it { should have_many(:items).through(:item_ingredients) }
  end
end
