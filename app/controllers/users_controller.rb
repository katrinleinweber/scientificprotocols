class UsersController < ApplicationController
  before_action :set_user
  before_action :authenticate_user!, except: [:show]
  load_and_authorize_resource

  # GET /users/1
  def show
    set_octokit_client(true)
    set_globals
    if @editable
      @protocols = @user.protocols.paginate(page: params[:page])
    else
      @protocols = @user.protocols.with_published_state.paginate(page: params[:page])
    end
  end

  # GET /users/1/starred
  def starred
    set_octokit_client
    @protocols = @user.starred_protocols(params: params)
    set_globals
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

    # Setup globals used by multiple actions.
    def set_globals
      @github_user = @user.octokit_client.user(@user.username)
      @avatar_url = @github_user.avatar_url
      @editable = (current_user == @user)
      @contributions = @user.protocols.with_published_state.count
    end
end