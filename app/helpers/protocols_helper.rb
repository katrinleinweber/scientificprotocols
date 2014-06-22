module ProtocolsHelper
  # Get the class used for the list of facets.
  #
  # @param [Hash] params The query string params.
  # @param [String] facet_name The name of the current facet being styled.
  def get_facet_list_class(params, facet_name)
    list_class = 'list-group-item'
    if params[:facet].present? && params[:facet] == facet_name
      list_class << ' active'
    end
    return list_class
  end
end
