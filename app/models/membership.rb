class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :club

  enum member_type: { member: 0, manager: 1 }
end
