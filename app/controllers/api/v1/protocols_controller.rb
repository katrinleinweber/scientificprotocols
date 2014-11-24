class Api::V1::ProtocolsController < Api::V1::BaseController
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
    @protocols = Protocol.search(params.reverse_merge!(paginate: false))
    respond_with(@protocols)
  end
end