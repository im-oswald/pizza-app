# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrderCreationService do
  let(:orders_data) { YAML.load_file(Rails.root.join('lib/data/orders.yml')) }
  let(:service) { described_class.new([order_data]) }

  describe '#call' do
    describe 'when there is no exception' do
      context 'For Order 1' do
        let(:order_data) { orders_data[0] }

        it 'creates the expected Order and Items' do
          expect(service).to receive(:create_order).with(order_data).and_call_original
          expect(service).to receive(:create_items).and_call_original

          expect {
            service.send(:call)
          }.to change { Order.count }.by(1)
           .and change { Item.count }.by(1)
           .and change { Ingredient.count }.by(0)
           .and change { PromotionCode.count }.by(0)
           .and change { DiscountCode.count }.by(0)

          order = Order.last
          expect(order.items.count).to eq(1)
          expect(order.items.first.name).to eq('Tonno')
          expect(order.items.first.size).to eq('large')
        end
      end

      context 'For Order 2' do
        let(:order_data) { orders_data[1] }

        it 'creates the expected Order' do
          expect(service).to receive(:create_order).with(order_data).and_call_original
          expect(service).to receive(:create_promotion_codes).and_call_original
          expect(service).to receive(:create_discount_code).and_call_original

          expect {
            service.send(:call)
          }.to change { Order.count }.by(1)
           .and change { PromotionCode.count }.by(0)
           .and change { DiscountCode.count }.by(0)

          order = Order.last
          expect(order.items.count).to eq(3)
          expect(order.items.pluck(:name)).to contain_exactly('Margherita', 'Tonno', 'Margherita')
          expect(order.items.pluck(:size)).to contain_exactly('large', 'medium', 'small')
        end

        it 'creates the expected Items' do
          expect(service).to receive(:create_items).and_call_original

          expect { service.send(:call) }.to change { Item.count }.by(3)

          # check items
          item_ingredients = ItemIngredient.all
          expect(item_ingredients.count).to eq(5)

          # check items ingredients
          order = Order.last
          expect(item_ingredients.pluck(:item_id)).to contain_exactly(
            order.items.first.id, order.items.first.id, order.items.first.id,
            order.items.second.id, order.items.second.id
          )
        end

        it 'creates the expected Items Ingredients' do
          # 3 items * 2 ingredients each (add and remove)
          expect(service).to receive(:create_item_ingredients).exactly(6).times.and_call_original

          expect { service.send(:call) }.to change { Ingredient.count }.by(3)
        end
      end

      context 'For Order 3' do
        let(:order_data) { orders_data[2] }

        it 'creates the expected Order' do
          expect(service).to receive(:create_order).with(order_data).and_call_original

          expect { service.send(:call) }.to change { Order.count }.by(1)
        end

        it 'creates the expected Items' do
          expect(service).to receive(:create_items).and_call_original

          expect { service.send(:call) }.to change { Item.count }.by(5)
        end

        it 'creates the expected Items Ingredients' do
          # 5 items * 2 ingredients each (add and remove)
          expect(service).to receive(:create_item_ingredients).exactly(10).times.and_call_original

          expect { service.send(:call) }.to change { Ingredient.count }.by(3)

          # check items ingredients
          item_ingredients = ItemIngredient.all
          expect(item_ingredients.count).to eq(3)

          order = Order.last
          expect(item_ingredients.pluck(:item_id)).to contain_exactly(
            order.items.first.id, order.items.first.id, order.items.last.id
          )
        end

        it 'creates the expected Promotions' do
          expect(service).to receive(:create_promotion_codes).and_call_original

          expect { service.send(:call) }.to change { PromotionCode.count }.by(1)
        end

        it 'creates the expected Discounts' do
          expect(service).to receive(:create_discount_code).and_call_original

          expect { service.send(:call) }.to change { DiscountCode.count }.by(1)
        end
      end
    end

    context 'when there is an exception' do
      let(:order_data) { orders_data[0] }

      before do
        allow(service).to receive(:create_data_from_raw).and_raise(StandardError, 'Seed error')
      end

      it 'should raise a PriceCalculationException' do
        expect { service.send(:call) }.to raise_error(
          OrderCreationException, 'Error seeding orders: Seed error'
        )
      end
    end
  end
end
