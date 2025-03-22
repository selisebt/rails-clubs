class Announcement < ApplicationRecord
  belongs_to :club

  enum :priority, { low: 0, medium: 1, high: 2 }

  broadcasts_to "announcements"
end
