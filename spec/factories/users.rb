FactoryBot.define do
  factory :user do
    association :subscription
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    age { Faker::Number.number(digits: 2) }
  end
end
