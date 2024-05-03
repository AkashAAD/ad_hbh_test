FactoryBot.define do
  factory :transaction do
    association :user
    association :library_item
    status { 'borrowed' }
  end
end
