class User < ApplicationRecord
  belongs_to :subscription
  has_many :transactions
  has_many :library_items, through: :transactions

  def borrowed_books
    library_items.where(kind: 'book').where(transactions: { status: 'borrowed' })
  end

  def borrowed_magazines
    library_items.where(kind: 'magazine').where(transactions: { status: 'borrowed' })
  end
end
