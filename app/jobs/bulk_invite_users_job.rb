class BulkInviteUsersJob < ApplicationJob
  queue_as :default

  def perform(csv_data, inviter_id)
    require "csv"

<<<<<<< Updated upstream
    CSV.parse(csv_data, headers: true) do |row|
      email = row["email"]
      name = row["name"]
=======
    CSV.parse(csv_data, headers: true, skip_blanks: true) do |row|
      email = row["email"]&.strip
      name = row["name"]&.strip
      role_id = row["role_id"]&.strip
>>>>>>> Stashed changes

      next if email.blank?

      User.invite!(
        { email: email, name: name },
        User.find(inviter_id)
      )
    end
  rescue CSV::MalformedCSVError => e
    Rails.logger.error "CSV parsing error: #{e.message}"
    raise
  end
end
