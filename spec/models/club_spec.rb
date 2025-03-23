require 'rails_helper'

RSpec.describe Club, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
  end

  describe 'associations' do
    it { should have_many(:memberships).dependent(:destroy) }
    it { should have_many(:users).through(:memberships) }
  end

  describe 'creation' do
    let(:user) { create(:user) }
    let(:club) { build(:club) }

    it 'creates a valid club' do
      expect(club).to be_valid
      expect(club.save).to be true
    end

    it 'associates with creator' do
      club.users << user
      expect(club.users).to include(user)
    end
  end
end
