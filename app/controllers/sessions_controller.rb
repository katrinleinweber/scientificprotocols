class SessionsController < ApplicationController
  def new
    redirect_to GITHUB_AUTH_PATH
  end

  def create
    auth = request.env['omniauth.auth']
    error_message = ''
    if auth.present?
      user = User.from_omniauth(auth)
      if user.persisted?
        reset_session
        session[:user_id] = user.id
        session[:access_token] = auth.credentials.token
        redirect_to protocols_url, notice: t('notices.sessions.signed_in') and return
      else
        error_message = user.errors.full_messages.join(', ')
      end
    end
    redirect_to root_url, alert: t('alerts.sessions.authentication_failed', error: error_message)
  end

  def destroy
    reset_session
    redirect_to root_url, notice: t('notices.sessions.signed_out')
  end
end