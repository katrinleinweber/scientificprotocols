class Api::V1::ProtocolsController < Api::V1::BaseController
  def show
    if !is_integer_id(params[:id])
      @protocol = Protocol.find_by_slug(params[:id])
      respond_with(@protocol)
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  def index
    @protocols = Protocol.search(params)
    respond_with(@protocols)
  end
end