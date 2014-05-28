class ProtocolsController < ApplicationController
  before_filter :authenticate_user!, except: [:show, :index]
  before_action :set_protocol, only: [:show, :edit, :update, :destroy]

  # GET /protocols
  # GET /protocols.json
  def index
    @search = Protocol.search do
      fulltext params[:search]
      paginate(page: params[:page] || 1, per_page: Protocol.per_page)
    end
    @protocols = @search.results
  end

  # GET /protocols/1
  # GET /protocols/1.json
  def show
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

    respond_to do |format|
      if @protocol_manager.save
        format.html { redirect_to @protocol_manager.protocol, notice: 'Protocol was successfully created.' }
        format.json { render :show, status: :created, location: @protocol_manager.protocol }
      else
        format.html { render :new }
        format.json { render json: @protocol_manager.errors, status: :unprocessable_entity }
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
