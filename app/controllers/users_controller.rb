class UsersController < ApplicationController
  before_action :set_user

  def show
    set_octokit_client(true)
    @protocols = @user.protocols.paginate(page: params[:page])
    @github_user = @user.octokit_client.user(@user.username)
    @avatar_url = @github_user.avatar_url
  end

  private
    def set_user
      @user = User.friendly.find(params[:id])
    end

    # Setup the Octokit client for the user.
    # @param [Boolean] use_default_token Use the default access token for the Octokit Client.
    def set_octokit_client(use_default_token = false)
      access_token = session[:access_token]
      access_token = Rails.configuration.api_github if access_token.blank? && use_default_token
      @user.set_octokit_client(access_token) if access_token.present?
    end
end