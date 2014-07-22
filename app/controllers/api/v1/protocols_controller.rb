class Api::V1::ProtocolsController < Api::V1::BaseController
  load_resource :find_by => :slug 
  authorize_resource

  # GET /api/v1/protocols/protocol-slug
  def show
    if !is_integer_id(params[:id])
      @protocol = Protocol.find_by_slug(params[:id])
      respond_with(@protocol)
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  # GET /api/v1/protocols
  def index
    @protocols = @protocols.search(params)
    respond_with(@protocols)
  end

  # POST /api/v1/protocols
  def create
    Protocol.create! protocol_params
  end

  # PATCH /api/v1/protocols/protocol-slug
  def update

  end

  # DELETE /api/v1/protocols/protocol-slug
  def destroy

  end

  def protocol_params
    params.require(:protocol).permit(:title, :description, :tag_list)
  end 
  private :protocol_params
end