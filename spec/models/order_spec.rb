require 'rails_helper'

RSpec.describe Order, type: :model do
  describe "associations" do
    it { should have_many(:items) }
    it { should have_and_belong_to_many(:promotion_codes).join_table(:order_promotion_codes) }
    it { should belong_to(:discount_code).optional }
  end

  describe "scopes" do
    describe ".active" do
      let!(:open_order) { create(:order) }
      let!(:completed_order) { create(:order, :completed) }

      it "returns active orders" do
        active_orders = Order.active
        expect(active_orders).to include(open_order)
        expect(active_orders).not_to include(completed_order)
      end
    end
  end

  describe "#computed_price" do
    let(:order) { create(:order) }

    it "calls PriceCalculationService" do
      expect(PriceCalculationService).to receive(:call).with(order)

      order.computed_price
    end
  end

  describe "#calculate_total_price" do
    let(:order) { create(:order) }

    it "is called before save" do
      expect(order).to receive(:calculate_total_price)

      order.save
    end
  end
end