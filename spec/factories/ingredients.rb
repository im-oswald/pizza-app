# frozen_string_literal: true

FactoryBot.define do
  factory :ingredient do
    sequence(:name) { |n| "#{Faker::Food.ingredient} #{n}" }
  end
end
