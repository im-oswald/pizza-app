FactoryBot.define do
  factory :discount_code do
    code { Faker::Alphanumeric.alphanumeric(number: 6).upcase }
  end
end
