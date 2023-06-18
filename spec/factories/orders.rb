FactoryBot.define do
  factory :order do
    trait(:completed) {
      status { :completed }
    }

    association :discount_code, factory: :discount_code, strategy: :create
  end
end
