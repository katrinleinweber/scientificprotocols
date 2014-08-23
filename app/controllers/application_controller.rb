class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user
  helper_method :user_signed_in?
  helper_method :get_query_string_from_referrer

  private

  def authenticate_user!
    if !current_user
      redirect_to '/signup', notice: t('alerts.sessions.signin_required')
    end
  end

  def current_user
    begin
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    rescue Exception => e
      nil
    end
  end

  def user_signed_in?
    return true if current_user
  end

  # Get the query string from the request referrer.
  # @param [Request] request The request object to get the query string from.
  def get_query_string_from_referrer(request)
    query_string = nil
    begin
      query_string = URI.parse(request.referer).query
    rescue URI::InvalidURIError => e
      Rails.logger.warn("Could not parse #{request.referer}\n#{e.to_s}")
    end
    query_string
  end
end
