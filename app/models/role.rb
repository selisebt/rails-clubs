class Role < ApplicationRecord
  has_many :users
  has_many :permissions
end
