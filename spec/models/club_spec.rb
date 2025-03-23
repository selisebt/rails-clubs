require 'rails_helper'

RSpec.describe Club, type: :model do
  it "has a valid factory" do
    expect(build(:club)).to be_valid
  end

  let(:club) { build(:club) }

  describe "ActiveRecord associations" do
    it { expect(club).to have_many(:memberships).dependent(:destroy) }
    it { expect(club).to have_many(:users).through(:memberships) }
    it { expect(club).to have_many(:budgets).dependent(:destroy) }
  end

  describe "ActiveModel validations" do
    it { expect(club).to validate_presence_of(:name) }
    it { expect(club).to validate_presence_of(:description) }

    it { expect(club).to validate_uniqueness_of(:name) }
  end
end
