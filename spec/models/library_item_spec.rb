require 'rails_helper'

RSpec.describe LibraryItem, type: :model do
  describe 'associations' do
    it { should have_many(:transactions) }
  end
end
