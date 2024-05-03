[
  { plan_name: 'silver', books_limit: 2 },
  { plan_name: 'gold', books_limit: 3, magazines_limit: 1 },
  { plan_name: 'platinum', books_limit: 4, magazines_limit: 2 }
].each do |subscription|
  Subscription.create(subscription)
end

[
  { first_name: 'John', last_name: 'Smith', age: 17, subscription: Subscription.first },
  { first_name: 'Emily', last_name: 'Johnson', age: 20, subscription: Subscription.first },
  { first_name: 'Michael', last_name: 'Williams', age: 25, subscription: Subscription.second },
  { first_name: 'David', last_name: 'Miller', age: 30, subscription: Subscription.third }
].each do |user|
  User.create(user)
end

[
  { name: 'The Great Gatsby', ref_id: 'B001', genre: 'Fiction', kind: 'book' },
  { name: 'The Hobbit', ref_id: 'B002', genre: 'Fantasy', kind: 'book' },
  { name: 'To Kill a Mockingbird', ref_id: 'B003', genre: 'Drama', kind: 'book' },
  { name: 'National Geographic', ref_id: 'M004', genre: 'Science', kind: 'magazine' },
  { name: 'Vogue', ref_id: 'M005', genre: 'Fashion', kind: 'magazine' },
  { name: 'The Godfather', ref_id: 'B006', genre: 'Crime', kind: 'book'}
].each do |book|
  LibraryItem.create(book)
end
