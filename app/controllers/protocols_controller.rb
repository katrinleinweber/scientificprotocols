class ProtocolsController < ApplicationController
  before_filter :authenticate_user!, except: [:show, :index, :tags]
  before_action :set_protocol, only: [:show, :edit, :update, :destroy]
  before_filter :set_params, only: [:show, :index]
  load_and_authorize_resource except: [:tags]

  # GET /protocols
  # GET /protocols.json
  def index
    if params[:search].present?
      @search = Protocol.search do
        fulltext params[:search]
        facet :tag_list
        paginate(page: params[:page] || 1, per_page: Protocol.per_page)
        params[:tags].split('-').each {|tag| with(:tag_list, tag)} if params[:tags].present?
      end
      @protocols = @search.results
    else
      @protocols = Protocol.paginate(page: params[:page] || 1, per_page: Protocol.per_page)
      @protocols = @protocols.tagged_with(params[:tags].split('-')) if params[:tags].present?
      @protocols = @protocols.managed_by(User.find_by_username(params[:u])) if params[:u].present?
    end
    @facets = Protocol.tag_counts.order(:name)
  end

  # GET /protocols/1
  # GET /protocols/1.json
  def show
    @protocol_manager = ProtocolManager.where(protocol: @protocol, user: current_user).first if current_user.present?
    gist = OCTOKIT_CLIENT.gist(@protocol.gist_id)
    @revision_url = gist.html_url + '/revisions'
    @back_path = protocols_path
    query_string = URI.parse(request.referer).query
    if params[:controller] == 'protocols' && query_string.present?
      @back_path << '?' + query_string
    end
  end

  # GET /protocols/new
  def new
    @protocol = Protocol.new
  end

  # GET /protocols/1/edit
  def edit

  end

  # POST /protocols
  # POST /protocols.json
  def create
    @protocol_manager = ProtocolManager.new(user: current_user, protocol: Protocol.new(protocol_params))
    @protocol = @protocol_manager.protocol
    respond_to do |format|
      if @protocol_manager.save
        format.html { redirect_to @protocol, notice: 'Protocol was successfully created.' }
        format.json { render :show, status: :created, location: @protocol }
      else
        format.html { render :new }
        format.json { render json: @protocol.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /protocols/1
  # PATCH/PUT /protocols/1.json
  def update
    respond_to do |format|
      if @protocol.update(protocol_params)
        format.html { redirect_to @protocol, notice: 'Protocol was successfully updated.' }
        format.json { render :show, status: :ok, location: @protocol }
      else
        format.html { render :edit }
        format.json { render json: @protocol.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /protocols/1
  # DELETE /protocols/1.json
  def destroy
    respond_to do |format|
      if @protocol.destroy
        format.html { redirect_to protocols_url, notice: 'Protocol was successfully deleted.' }
        format.json { head :no_content }
      else
        format.html { redirect_to @protocol, alert: 'Protocol deletion failed.' }
        format.json { render json: @protocol.errors, status: :unprocessable_entity }
      end
    end
  end

  def tags
    @tokens = params[:term].present? ? ActsAsTaggableOn::Tag.named_like(params[:term]).map(&:name) : ActsAsTaggableOn::Tag.all.map(&:name)
    respond_to do |format|
      format.json { render json: @tokens }
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

    # Get a hash of approved query string params.
    def set_params
      @params = params.slice(:page, :u, :search, :utf8, :tags)
    end
end
