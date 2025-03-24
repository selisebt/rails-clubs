class Club < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :budgets, dependent: :destroy

  validates :name, presence: true
end
