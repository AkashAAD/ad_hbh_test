class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :library_item

  validate :validate_plan,
    :validate_age,
    :validate_transactions, on: :create

  after_save :update_book_availability

  private

  def validate_plan
    if user.borrowed_books.count >= user.subscription.books_limit
       errors.add(:base, "User is not allowed to borrow more than #{user.subscription.books_limit} books.")
    elsif user.borrowed_magazines.count >= user.subscription.magazines_limit && library_item.kind == 'magazine'
       errors.add(:base, "User is not allowed to borrow more than #{user.subscription.magazines_limit} magazines.")
    end
  end

  def validate_age
    if user.age < 18 && library_item.kind == 'book' && library_item.genre == 'Crime'
      errors.add(:base, 'User is under age to read the crime books.')
    end
  end

  def validate_transactions
    transactions_count = user
      .transactions
      .where(created_at: Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)
      .count
    if transactions_count >= 10
      errors.add(:base, 'Only 10 transactions are valid in this month.')
    end
  end

  def update_book_availability
    library_item.update(availability: status == 'return') if %w[borrowed return].include?(status)
  end
end
