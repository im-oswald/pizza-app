# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    name { %w[Margharita Tonno Salami].sample }
    size { Item.sizes.keys.sample }

    association :order, factory: :order, strategy: :create
  end
end
