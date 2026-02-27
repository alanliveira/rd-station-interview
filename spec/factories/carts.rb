FactoryBot.define do
  factory :cart do
    total_price { 0 }

    # cria automaticamente um shopping_cart se você quiser
    trait :with_shopping_cart do
      after(:create) do |cart|
        create(:shopping_cart, cart: cart)
      end
    end

    trait :with_items do
      after(:create) do |cart|
        create_list(:cart_item, 3, cart: cart)
        cart.calculate_total_price
      end
    end
  end
end
