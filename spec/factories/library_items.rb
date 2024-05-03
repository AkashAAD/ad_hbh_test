FactoryBot.define do
  factory :library_item do
    name { Faker::Book.title }
    ref_id { "BM#{(rand *100)}" }
    genre { 'Fantacy' }
    kind { 'book' }
    availability { true }
  end
end
