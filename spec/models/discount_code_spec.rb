require 'rails_helper'

RSpec.describe DiscountCode, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:code) }

    context 'validates uniqueness of code' do
      let(:existing_discount_code) { create(:discount_code, code: 'Existing Code') }
      let(:new_discount_code) { build(:discount_code, code: 'Existing Code') }

      it 'should invalidate duplicate code' do
        expect(existing_discount_code).to be_valid

        expect(new_discount_code).not_to be_valid
        expect(new_discount_code.errors[:code]).to include('has already been taken')
      end
    end
  end

  describe 'associations' do
    it { should have_many(:orders).dependent(:nullify) }
  end
end
