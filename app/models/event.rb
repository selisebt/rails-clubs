class Event < ApplicationRecord
  belongs_to :club

  enum :status, { scheduled: 0, ongoing: 1, completed: 2 }
end
