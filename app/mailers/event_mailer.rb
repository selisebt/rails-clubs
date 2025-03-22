class EventMailer < ApplicationMailer
  def reminder_email(event_id)
    @event = Event.find(event_id)
    mail(
      to: 'kw2@selisegroup.com',
      subject: 'Event reminder'
    )
  end
end
