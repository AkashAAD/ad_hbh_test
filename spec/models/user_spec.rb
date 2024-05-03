require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:transactions) }
    it { should have_many(:library_items).through(:transactions) }
    it { should belong_to(:subscription) }
  end

  describe '#borrowed_books' do
    let(:user) { create(:user, subscription: subscription) }
    let(:subscription) { create(:subscription) }
    let(:magazine) { create(:library_item, kind: 'magazine') }
    let(:book1) { create(:library_item, kind: 'book') }
    let(:book2) { create(:library_item, kind: 'book') }

    before do
      create(:transaction, user: user, library_item: book1, status: 'borrowed')
      create(:transaction, user: user, library_item: book2, status: 'borrowed')
    end

    it 'returns borrowed books' do
      expect(user.borrowed_books).to include(book1, book2)
    end

    it 'does not return borrowed magazines' do
      expect(user.borrowed_books).not_to include(magazine)
    end
  end

  describe '#borrowed_magazines' do
    let(:user) { create(:user, subscription: build(:subscription, plan_name: 'Gold', books_limit: 3, magazines_limit: 1)) }
    let(:book) { create(:library_item, kind: 'book') }
    let(:magazine) { create(:library_item, kind: 'magazine') }

    before do
      create(:transaction, user: user, library_item: book, status: 'borrowed')
      create(:transaction, user: user, library_item: magazine, status: 'borrowed')
    end

    it 'returns borrowed magazines' do
      expect(user.borrowed_magazines).to include(magazine)
    end

    it 'does not return borrowed books' do
      expect(user.borrowed_magazines).not_to include(book)
    end
  end
end
