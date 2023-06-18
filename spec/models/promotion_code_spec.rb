require 'rails_helper'

RSpec.describe PromotionCode, type: :model do
  describe "validations" do
    it { should validate_presence_of(:code) }

    context 'validates uniqueness of code' do
      let(:existing_promotion_code) { create(:promotion_code, code: 'Existing Code') }
      let(:new_promotion_code) { build(:promotion_code, code: 'Existing Code') }

      it 'should invalidate duplicate code' do
        expect(existing_promotion_code).to be_valid

        expect(new_promotion_code).not_to be_valid
        expect(new_promotion_code.errors[:code]).to include('has already been taken')
      end
    end
  end

  describe "associations" do
    it { should have_and_belong_to_many(:orders).join_table(:order_promotion_codes) }
  end
end
