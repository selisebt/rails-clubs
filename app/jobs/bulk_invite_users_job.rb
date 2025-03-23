class BulkInviteUsersJob < ApplicationJob
  queue_as :default

  def perform(csv_data, inviter_id)
    require "csv"

    CSV.parse(csv_data, headers: true) do |row|
      email = row["email"]
      name = row["name"]

      next if email.blank?

      User.invite!(
        { email: email, name: name },
        User.find(inviter_id)
      )
    end
  end
end
