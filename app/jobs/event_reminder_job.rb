class EventReminderJob < ApplicationJob
  queue_as :default

  def perform
    events = Event.where(status: "published")
                  .where("from BETWEEN ? AND ?", 1.day.from_now.beginning_of_day, 1.day.from_now.end_of_day)

    events.each do |event|
      EventMailer.reminder_email(event.id).deliver_now
    end
  end
end
