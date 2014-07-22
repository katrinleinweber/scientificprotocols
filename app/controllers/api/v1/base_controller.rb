class Api::V1::BaseController < ActionController::Base
  respond_to :json

  rescue_from Exception, with: :internal_server_error

  def is_integer_id(id)
    begin
      !!Integer(id)
      true
    rescue ArgumentError, TypeError
      false
    end
  end

  # TODO(golyshev) Add default rendering fo the 404, 403 pages

  protected :is_integer_id

  def internal_server_error(exception = nil)
    result = {error: 'internal_server_error'}
    result.merge!({debug_message: exception.message}) if exception
    if exception
      logger.error exception.message
      logger.error exception.backtrace.join("\n")
    end
    respond_with(result, status: :internal_server_error)
  end

  protected :internal_server_error

end