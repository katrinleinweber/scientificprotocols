class ProtocolsController < ApplicationController
  before_filter :authenticate_user!, except: [:show, :index]
  before_action :set_protocol, only: [:show, :edit, :update, :destroy]
  #load_and_authorize_resource TODO

  # GET /protocols
  # GET /protocols.json
  def index
    if params[:search].present?
      @search = Protocol.search do
        fulltext params[:search]
        paginate(page: params[:page] || 1, per_page: Protocol.per_page)
      end
      @protocols = @search.results
    else
      @protocols = Protocol.paginate(page: params[:page] || 1, per_page: Protocol.per_page)
    end
    @protocols = @protocols.managed_by(User.find_by_username(params[:u])) if params[:u].present?
  end

  # GET /protocols/1
  # GET /protocols/1.json
  def show
    @protocol_manager = ProtocolManager.where(protocol: @protocol, user: current_user).first if current_user.present?
    gist = OCTOKIT_CLIENT.gist(@protocol.gist_id)
    @revision_url = gist.html_url + '/revisions'
    @back_path = protocols_path
    if params[:controller] == 'protocols'
      user_id = get_query_string_param(:u)
      @back_path = protocols_path({u: user_id}) if user_id.present?
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
    @protocol.destroy
    respond_to do |format|
      format.html { redirect_to protocols_url, notice: 'Protocol was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_protocol
      @protocol = Protocol.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def protocol_params
      params.require(:protocol).permit(:title, :description)
    end
end
