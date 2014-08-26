class ProtocolsController < ApplicationController
  before_filter :authenticate_user!, except: [:show, :index, :tags]
  before_action :set_protocol, only: [:show, :edit, :update, :destroy, :star, :unstar, :fork, :discussion]
  before_filter :set_params, only: [:show, :index]
  before_filter :set_octokit_client, only: [:update, :destroy, :star, :unstar, :fork, :discussion]
  before_filter :set_gist, only: [:star, :unstar, :fork, :discussion]
  load_and_authorize_resource except: [:tags]

  # GET /protocols
  def index
    @protocols = Protocol.search(params)
    @facets = Protocol.facets(Protocol.search(params, paginate: false))
    respond_to do |format|
      format.html
    end
  end

  # GET /protocols/1
  def show
    set_globals
    respond_to do |format|
      format.html
    end
  end

  # GET /protocols/new
  def new
    @protocol = Protocol.new
    respond_to do |format|
      format.html
    end
  end

  # GET /protocols/1/edit
  def edit
    respond_to do |format|
      format.html
    end
  end

  # POST /protocols
  def create
    @protocol_manager = ProtocolManager.new(user: current_user, protocol: Protocol.new(protocol_params))
    @protocol = @protocol_manager.protocol
    set_octokit_client
    respond_to do |format|
      if @protocol_manager.save
        format.html { redirect_to @protocol, notice: t('notices.protocols.create') }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /protocols/1
  def update
    respond_to do |format|
      if @protocol.update(protocol_params)
        format.html { redirect_to @protocol, notice: t('notices.protocols.update') }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /protocols/1
  def destroy
    respond_to do |format|
      if @protocol.destroy
        format.html { redirect_to protocols_url, notice: t('notices.protocols.delete') }
      else
        format.html { redirect_to @protocol, alert: t('alerts.protocols.delete_failed') }
      end
    end
  end

  def tags
    @tokens = params[:term].present? ? ActsAsTaggableOn::Tag.named_like(params[:term]).map(&:name) : ActsAsTaggableOn::Tag.all.map(&:name)
    respond_to do |format|
      format.json { render json: @tokens, root: false }
    end
  end

  def star
    respond_to do |format|
      if @protocol.octokit_client.star_gist(@protocol.gist.id)
        format.html { redirect_to @protocol, notice: t('notices.protocols.starred') }
      else
        format.html { redirect_to @protocol, alert: t('alerts.protocols.starred_failed') }
      end
    end
  end

  def unstar
    respond_to do |format|
      if @protocol.octokit_client.unstar_gist(@protocol.gist.id)
        format.html { redirect_to @protocol, notice: t('notices.protocols.unstarred') }
      else
        format.html { redirect_to @protocol, alert: t('alerts.protocols.unstarred_failed') }
      end
    end
  end

  def fork
    new_protocol = @protocol.fork(@protocol.gist.id, current_user)
    respond_to do |format|
      if new_protocol.present?
        format.html { redirect_to new_protocol, notice: t('notices.protocols.forked') }
      else
        format.html { redirect_to @protocol, alert: t('alerts.protocols.forked_failed') }
      end
    end
  end

  def discussion
    set_globals
    @comments = @protocol.octokit_client.gist_comments(@protocol.gist.id)
    respond_to do |format|
      format.html
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_protocol
      @protocol = Protocol.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def protocol_params
      params.require(:protocol).permit(:title, :description, :tag_list)
    end

    # Set the Gist associated with the protocol.
    def set_gist
      @protocol.gist = @protocol.octokit_client.gist(@protocol.gist_id)
    end

    # Get a hash of approved query string params.
    def set_params
      @params = params.slice(:page, :u, :search, :utf8, :tags)
    end

    # Setup the Octokit client for the protocol.
    # @param [Boolean] use_default_token Use the default access token for the Octokit Client.
    def set_octokit_client(use_default_token = false)
      access_token = session[:access_token]
      access_token = Rails.configuration.api_github if access_token.blank? && use_default_token
      @protocol.set_octokit_client(access_token) if access_token.present?
    end

    # Setup globals used by multiple actions.
    def set_globals
      set_octokit_client(true)
      set_gist
      @protocol_manager = ProtocolManager.where(protocol: @protocol, user: current_user).first if current_user.present?
      @revision_url = @protocol.gist_revision_url
      @back_path = protocols_path
      query_string = get_query_string_from_referrer(request)
      if params[:controller] == 'protocols' && query_string.present?
        @back_path << '?' + query_string
      end
      @gist_starred = @protocol.octokit_client.gist_starred?(@protocol.gist.id)
      @forkable = current_user.present? && @protocol_manager.blank?
      @fork_of = @protocol.gist.fork_of.present? ? Protocol.find_by_gist_id(@protocol.gist.fork_of.id) : nil
      @embed_script = @protocol.gist_embed_script
    end
end
