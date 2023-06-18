FactoryBot.define do
  factory :item_ingredient do
    ingredient_type { ItemIngredient.ingredient_types.keys.sample }

    trait(:add_ingredient) { ingredient_type { :add_ingredient } }
    trait(:remove_ingredient) { ingredient_type { :remove_ingredient } }

    association :item, factory: :item, strategy: :create
    association :ingredient, factory: :ingredient, strategy: :create
  end
end
