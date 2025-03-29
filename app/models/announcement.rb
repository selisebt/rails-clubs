class Announcement < ApplicationRecord
  belongs_to :club

  enum :priority, { low: 0, medium: 1, high: 2 }

  validates :message, :title, presence: true
end
