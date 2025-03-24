# frozen_string_literal: true

def api_response
  result = JSON.parse(response.body)
  result.is_a?(Array) ? result : ActiveSupport::HashWithIndifferentAccess.new(result)
end

def authenticate_user(user)
  sign_in user if user
end
