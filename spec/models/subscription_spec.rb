require 'rails_helper'

RSpec.describe Subscription, type: :model do
  describe 'associations' do
    it { should have_many(:users) }
  end
end
