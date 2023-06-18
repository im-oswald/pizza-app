require 'rails_helper'

RSpec.describe OrderCreationService do
  let(:data) do
    [
      {
        'id' => '316c6832-e038-4599-bc32-2b0bf1b9f1c1',
        'state' => 'OPEN',
        'createdAt' => '2021-04-14T11:16:00Z',
        'items' => [
          {
            'name' => 'Tonno',
            'size' => 'Large',
            'add' => [],
            'remove' => []
          }
        ],
        'promotionCodes' => [],
        'discountCode' => nil
      }
    ]
  end
  subject { described_class.new(data) }

  describe '.call' do
    let(:order) { instance_double(Order) }

    it 'creates orders and associated records' do
      allow(Order).to receive(:transaction).and_yield

      allow(Order).to receive(:find_by).with(uuid: '316c6832-e038-4599-bc32-2b0bf1b9f1c1').and_return(nil)
      allow(subject).to receive(:create_data_from_raw).with(data[0]).and_return(order)
      allow(order).to receive(:save!)
    
      described_class.call(data)
    end

    it 'raises an error when there is an exception' do
      error_message = 'Something went wrong'

      expect(Order).to receive(:transaction).and_raise(StandardError.new(error_message))

      expect { described_class.call(data) }.to raise_error(OrderCreationServiceException, "Error seeding orders: #{error_message}")
    end
  end

  describe '#create_data_from_raw' do
    let(:raw_order) { data[0] }

    let(:order) { instance_double(Order) }

    before do
      allow(subject).to receive(:create_order).and_return(order)
      allow(subject).to receive(:create_items)
      allow(subject).to receive(:create_promotion_codes)
      allow(subject).to receive(:create_discount_code)
    end

    it 'creates order and associated records' do
      expect(subject).to receive(:create_order).with(raw_order).and_return(order)
      expect(subject).to receive(:create_items).with(raw_order['items'], order)
      expect(subject).to receive(:create_promotion_codes).with(raw_order['promotionCodes'], order)
      expect(subject).to receive(:create_discount_code).with(raw_order['discountCode'], order)
      expect(order).to receive(:save!)

      subject.send(:create_data_from_raw, raw_order)
    end
  end
end
