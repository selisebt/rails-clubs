# frozen_string_literal: true

module ErrorHandler
  def self.included(base)
    base.class_eval do
      rescue_from StandardError, with: :bad_request
      rescue_from NoMethodError, with: :bad_request
      rescue_from ActionController::ParameterMissing, with: :bad_request
      rescue_from ActiveRecord::RecordNotFound, with: :document_not_found
    end
  end

  def document_not_found(error)
    render_error_page(404, error: { message: error.message })
  end

  def not_authorized(error)
    render_error_page(403, error: { message: error.message })
  end

  def server_error(error)
    render_error_page(500, error: { message: error.message })
  end

  def gateway_timeout(error)
    render_error_page(504, error: { message: error.message })
  end

  def unauthorized(error)
    render_error_page(401, error: { message: error.message })
  end

  def bad_request(error)
    render_error_page(400, error: { message: error.message })
  end

  def too_many_request(error)
    render_error_page(429, error: { message: error.message })
  end

  def service_unavailable(error)
    render_error_page(503, error: { message: error.message })
  end

  def bad_gateway(error)
    render_error_page(502, error: { message: error.message })
  end

  def render_error_page(status, _error_options = {})
    send_data(
      File.read(Rails.root.join('public', "#{status}.html")),
      type: 'text/html',
      disposition: :inline,
      status: status
    )
  end
end
