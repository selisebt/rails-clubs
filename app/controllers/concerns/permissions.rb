# frozen_string_literal: true

module Permissions
  def permit(user, resource, action, additional_check = true)
    permission = user&.role&.permissions&.find_by(resource: resource)
    return false unless permission.present?

    permission.actions[action] && additional_check
  end

  def permit!(user, resource, action, additional_check = true)
    raise(ActionController::InvalidAuthenticityToken.new("Access forbidden"), error_message) unless permit(user, resource, action, additional_check)

    true
  end

  def error_message
    "You don't have permission to perform this action"
  end
end
