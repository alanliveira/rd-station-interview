FactoryBot.define do
  factory :shopping_cart do
    status { 'pending' }
    last_interaction_at { Time.current }
  end
end
