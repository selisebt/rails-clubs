class BulkInviteUsersJob < ApplicationJob
  queue_as :default

  def perform(csv_data, inviter_id)
    require "csv"

    CSV.parse(csv_data, headers: true) do |row|
      email = row["email"]
      name = row["name"]
      role_id = row["role_id"]

      next if email.blank?

      User.invite!(
        { email: email, name: name, role_id: role_id },
        User.find(inviter_id)
      )
    end
  end
end
