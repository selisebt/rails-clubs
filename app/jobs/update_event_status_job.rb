class UpdateEventStatusJob < ApplicationJob
  queue_as :default

  def perform
    now = Time.current

    # Update events that should be ongoing
    Event.where(status: :scheduled)
         .where('from <= ? AND to > ?', now, now)
         .update_all(status: :ongoing)

    # Update events that should be completed
    Event.where(status: [:scheduled, :ongoing])
         .where('to <= ?', now)
         .update_all(status: :completed)
  end
end 