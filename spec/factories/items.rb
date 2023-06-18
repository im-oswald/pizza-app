FactoryBot.define do
  factory :item do
    name { Faker::Food.dish }
    size { Item.sizes.keys.sample }

    association :order, factory: :order, strategy: :create
  end
end
