FactoryBot.define do
  factory :cart do
    total_price { 0 }
    last_interaction_at { Time.current }
    status { 'pending' }

    trait :with_items do
      after(:create) do |cart|
        create_list(:cart_item, 3, cart: cart)
        cart.calculate_total_price
      end
    end
  end
end
