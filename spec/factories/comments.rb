FactoryBot.define do
  factory :comment do
    sequence(:body) { |n| "Comment body #{n}" }

    trait :invalid do
      body { nil }
    end
  end
end
