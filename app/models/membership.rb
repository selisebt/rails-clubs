class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :club

  enum role: { member: 0, manager: 1 }
end
