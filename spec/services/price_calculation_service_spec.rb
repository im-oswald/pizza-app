require 'rails_helper'

RSpec.describe PriceCalculationService do
  describe '.call' do
    let(:order) { create(:order) }
    let(:service) { described_class.new(order) }

    context 'when price calculation is successful' do
      before do
        allow(service).to receive(:calculate_total_price).and_return(10)
        allow(service).to receive(:apply_promotion_codes).and_return(7)
        allow(service).to receive(:apply_discount).and_return(6)
      end

      it 'returns the calculated price' do
        expect(service.call).to eq(6)
      end
    end

    context 'when an error occurs during price calculation' do
      before do
        allow(service).to receive(:calculate_total_price).and_raise(StandardError, 'Calculation error')
      end

      it 'raises a PriceCalculationException with the error message' do
        expect { service.call }.to raise_error(PriceCalculationException, 'Error calculating order: Calculation error')
      end
    end
  end

  describe '#call' do
    let(:order) { create(:order) }
    let(:service) { described_class.new(order) }

    it 'returns the calculated price' do
      allow(service).to receive(:calculate_total_price).and_return(10)
      allow(service).to receive(:apply_promotion_codes).and_return(7)
      allow(service).to receive(:apply_discount).and_return(6)

      expect(service.send(:call)).to eq(6)
    end

    it 'raises a PriceCalculationException if an error occurs' do
      allow(service).to receive(:calculate_total_price).and_raise(StandardError, 'Calculation error')

      expect { service.send(:call) }.to raise_error(
        PriceCalculationException, 'Error calculating order: Calculation error'
      )
    end
  end
end
