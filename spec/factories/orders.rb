# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    trait(:completed) do
      status { :completed }
    end

    association :discount_code, factory: :discount_code, strategy: :create
  end
end
