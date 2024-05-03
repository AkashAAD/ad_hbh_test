require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'associations' do
    it do
     expect(described_class.reflect_on_association(:user).macro).to eq(:belongs_to)
    end

    it do
     expect(described_class.reflect_on_association(:library_item).macro).to eq(:belongs_to)
    end
  end

  describe 'validates' do
    context 'on create' do
      it 'validates plan' do
        transaction = create(
          :transaction,
          user: build(:user, subscription: build(:subscription, plan_name: 'Silver', books_limit: 2, magazines_limit: 0)),
          library_item: build(:library_item)
        )

        expect(transaction).to be_valid
      end

      it 'validates age' do
        transaction = create(
          :transaction,
          user: build(:user, age: 18, subscription: build(:subscription, plan_name: 'Silver', books_limit: 2, magazines_limit: 0)),
          library_item: build(:library_item)
        )

        expect(transaction).to be_valid
      end

      it 'validates transactions' do
        transaction = create(
          :transaction,
          user: build(:user,subscription: build(:subscription)),
          library_item: build(:library_item)
        )

        expect(transaction).to be_valid
      end
    end
  end

  describe 'callbacks' do
    context 'when transaction create or update' do
      it 'updates book availability after save' do
        transaction = create(
          :transaction,
          user: build(:user,subscription: build(:subscription)),
          library_item: build(:library_item),
          status: 'return'
        )

        expect(LibraryItem.last.availability).to be_truthy

        transaction.update(status: 'borrowed')
        expect(LibraryItem.last.availability).to be_falsey
      end
    end
  end
end
