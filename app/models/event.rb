class Event < ApplicationRecord
  belongs_to :club

  enum :status, { scheduled: 0, ongoing: 1, completed: 2 }

  # # Exercise: Uncomment this block to enable event creation validations.
  # # Validations
  # validates :name, presence: true, length: { minimum: 3, maximum: 100 }
  # validates :description, presence: true, length: { minimum: 10, maximum: 1000 }
  # validates :from, presence: true
  # validates :to, presence: true
  # validates :status, presence: true, inclusion: { in: statuses.keys }
  # validates :club_id, presence: true
  #
  # # Custom validations
  # validate :end_time_after_start_time
  # validate :start_time_in_future

  private

  def end_time_after_start_time
    return if from.blank? || to.blank?

    if to <= from
      errors.add(:to, "date and time must be after start time")
    end
  end

  def start_time_in_future
    return if from.blank?

    if from < Time.current
      errors.add(:from, "date and time must be in the future")
    end
  end
end