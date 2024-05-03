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

  describe 'invalidates' do
    context 'on create' do
      context 'when library_item is magazine' do
        it 'invalidates plan' do
          transaction = build(
            :transaction,
            user: create(:user, subscription: create(:subscription, plan_name: 'Silver', books_limit: 2, magazines_limit: 0)),
            library_item: create(:library_item, kind: 'magazine')
          )

          expect(transaction).not_to be_valid
        end
      end

      context 'when library_item is book' do
        it 'invalidates plan' do
          transaction = build(
            :transaction,
            user: create(:user, subscription: create(:subscription, plan_name: 'Silver', books_limit: 0, magazines_limit: 0)),
            library_item: create(:library_item, kind: 'book')
          )

          expect(transaction).not_to be_valid
        end
      end

      it 'invalidates age' do
        transaction = build(
          :transaction,
          user: build(:user, age: 17, subscription: build(:subscription, plan_name: 'Silver', books_limit: 2, magazines_limit: 0)),
          library_item: build(:library_item, genre: 'Crime', kind: 'book')
        )

        expect(transaction).not_to be_valid
      end

      it 'invalidates transactions' do
        user = build(:user,subscription: build(:subscription))

        10.times do
          transaction = create(
            :transaction,
            user: user,
            library_item: build(:library_item)
          )

          transaction.update(status: 'return')
        end

        transaction = build(
          :transaction,
          user: user,
          library_item: build(:library_item)
        )

        expect(transaction).not_to be_valid
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
