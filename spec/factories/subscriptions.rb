FactoryBot.define do
  factory :subscription do
    plan_name { 'Silver' }
    books_limit { 2 }
    magazines_limit { 0 }
  end
end
