# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    trait(:completed) do
      status { :completed }
    end

    trait(:with_items) do
      transient do
        items_count { 2 }
      end

      after(:create) do |order, evaluator|
        create_list(:item, evaluator.items_count, order:)
      end
    end

    association :discount_code, factory: :discount_code, strategy: :create
  end
end
