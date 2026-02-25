FactoryBot.define do
  factory :cart do
    total_price { Faker::Commerce.price }
  end
end
