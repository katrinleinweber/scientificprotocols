class Api::V1::BaseController < ActionController::Base
  respond_to :json


  def is_integer_id(id)
    begin
      !!Integer(id)
      true
    rescue ArgumentError, TypeError
      false
    end
  end

  # TODO(golyshev) Add default rendering fo the 404, 500, 403 pages

  protected :is_integer_id

end