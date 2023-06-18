FactoryBot.define do
  factory :promotion_code do
    code { Faker::Alphanumeric.alphanumeric(number: 6).upcase }
  end
end
