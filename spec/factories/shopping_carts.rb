FactoryBot.define do
  factory :shopping_cart do
    association :cart
    status { :pending }
    last_interaction_at { Time.current }

    trait :abandoned do
      status { :abandoned }
    end

    trait :expired do
      status { :abandoned }
      last_interaction_at { 8.days.ago }
    end
  end
end
