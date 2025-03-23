class Club < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :budgets, dependent: :destroy
  has_many :events, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true
end
