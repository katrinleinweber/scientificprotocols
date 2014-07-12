class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end
  # Get the query string from the request referrer.
  # @param [Request] request The request object to get the query string from.
  def get_query_string_from_referrer(request)
    query_string = nil
    begin
      query_string = URI.parse(request.referer).query
      Rails.logger.info("Query string: #{query_string}")
    rescue URI::InvalidURIError => e
      Rails.logger.warn("Could not parse #{request.referer}\n#{e.to_s}")
    end
    query_string
  end
end
