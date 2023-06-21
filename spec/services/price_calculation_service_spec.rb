# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PriceCalculationService do
  let(:orders_data) { YAML.load_file(Rails.root.join('lib/data/orders.yml')) }
  let(:service) { described_class.new(order) }

  describe '#call' do
    describe 'when there is no exception' do
      context 'For Order 1' do
        let(:order_data) { orders_data[0] }

        before { OrderCreationService.call([order_data]) }

        let(:order) { Order.find_by(uuid: order_data['id']) }

        it 'returns the expected price' do
          expect(service).to receive(:calculate_total_price).and_return(10.4)

          expect(service.send(:call)).to eq(10.4)
        end

        it 'should not call the apply_promotions method' do
          expect(service).to_not receive(:apply_promotions)

          expect(service.send(:call)).to eq(10.4)
        end

        it 'should not call the apply_discount method' do
          expect(service).to_not receive(:apply_discount)

          expect(service.send(:call)).to eq(10.4)
        end
      end

      describe 'For Order 2' do
        let(:order_data) { orders_data[1] }

        before { OrderCreationService.call([order_data]) }

        let(:order) { Order.find_by(uuid: order_data['id']) }

        it 'returns the expected price' do
          expect(service).to receive(:calculate_total_price).and_return(25.15)

          expect(service.send(:call)).to eq(25.15)
        end

        it 'should not call the apply_promotions method' do
          expect(service).to_not receive(:apply_promotions)

          expect(service.send(:call)).to eq(25.15)
        end

        it 'should not call the apply_discount method' do
          expect(service).to_not receive(:apply_discount)

          expect(service.send(:call)).to eq(25.15)
        end
      end

      describe 'For Order 3' do
        let(:order_data) { orders_data[2] }

        before { OrderCreationService.call([order_data]) }

        let(:order) { Order.find_by(uuid: order_data['id']) }

        it 'returns the expected price' do
          expect(service).to receive(:calculate_total_price).and_return(25.54)
          expect(service).to receive(:apply_promotions).and_return(17.15)
          expect(service).to receive(:apply_discount).and_return(16.29)

          expect(service.send(:call)).to eq(16.29)
        end
      end
    end

    context 'when there is an exception' do
      let(:order) { double('Order') }

      before do
        allow(service).to receive(:calculate_total_price).and_raise(StandardError, 'Calculation error')
      end

      it 'should raise a PriceCalculationException' do
        expect { service.send(:call) }.to raise_error(
          PriceCalculationException, 'Error calculating order: Calculation error'
        )
      end
    end

    describe 'when the order has the discount code' do
      let(:order) { create(:order, :with_items) }

      context 'but the discount code is not valid' do
        it 'should not change the total' do
          expect(service).to receive(:apply_discount).and_call_original
          expect(service).to receive(:discount_percent).and_return(0)

          service.send(:call)
        end
      end

      context 'and the config file does not have the discount code' do
        before do
          expect(service.instance_variable_get(:@pricing_rules)
            .dig('discounts', order.discount_code&.code, 'deduction_in_percent')).to be_nil
        end

        it 'should not change the total' do
          expect(service).to receive(:apply_discount).and_call_original
          expect(service).to receive(:discount_percent).and_return(0)

          service.send(:call)
        end
      end
    end

    describe 'when the order has the promotion code' do
      let(:promotion_code) { create(:promotion_code) }
      let(:order) { create(:order, :with_items) }

      before do
        allow(order).to receive(:promotion_codes).and_return([promotion_code])
      end

      context 'but the promotion code is not valid' do
        it 'should not change the total' do
          expect(service).to receive(:apply_promotions).and_call_original
          expect(service).to receive(:apply_promo_code).and_return(0)

          service.send(:call)
        end
      end

      context 'and the config file has the promotion code but from or to is not there' do
        let(:new_pricing_rules) do
          {
            'size_multipliers': {
              'Small': 0.7,
              'Medium': 1,
              'Large': 1.3
            },
            'pizzas': {
              'Margherita': 5,
              'Salami': 6,
              'Tonno': 8
            },
            'ingredients': {
              'Onions': 1,
              'Cheese': 2,
              'Olives': 2.5
            },
            'promotions': {
              "#{promotion_code.code}": {
                'target': 'Salami',
                'target_size': 'Small',
                'from': 2
              }
            }
          }
        end

        before do
          service.instance_variable_set(:@pricing_rules, new_pricing_rules)
          expect(service.instance_variable_get(:@pricing_rules).dig('promotions', promotion_code&.code, 'to')).to be_nil
        end

        it 'should not change the total' do
          expect(service).to receive(:apply_promotions).and_call_original
          expect(service).to receive(:apply_promo_code).and_return(0)

          service.send(:call)
        end
      end

      context 'and the config file does not have the promotion code' do
        before do
          expect(service.instance_variable_get(:@pricing_rules).dig('promotions', promotion_code&.code)).to be_nil
        end

        it 'should not change the total' do
          expect(service).to receive(:apply_promotions).and_call_original
          expect(service).to receive(:apply_promo_code).and_return(0)

          service.send(:call)
        end
      end
    end
  end
end
