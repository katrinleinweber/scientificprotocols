class Service::DepositionManager
  # Create a Zenodo deposition so we can get a DOI.
  # @param [Hash] deposition The deposition attributes for creation.
  # @raise [ArgumentError] If the supplied protocol is blank.
  # @return [Zenodo::Resources::Deposition, nil] A Zenodo deposition resource.
  def self.create_deposition(deposition:)
    raise ArgumentError, "Deposition cannot be blank" if deposition.blank?
    begin
      deposition = Zenodo.client.create_deposition(deposition: deposition)
      return deposition
    rescue Zenodo::Errors::ClientError => e
      Rails.logger.error "Zenodo deposition create failed: #{e.inspect}"
    end
    nil
  end

  # Publish a Zenodo deposition so we can get a DOI.
  # @param [String, Fixnum] id A deposition's ID.
  # @raise [ArgumentError] If the supplied protocol is blank.
  # @return [Zenodo::Resources::Deposition, nil] A Zenodo deposition resource.
  def self.publish_deposition(id:)
    raise ArgumentError, "ID cannot be blank" if id.blank?
    begin
      deposition = Zenodo.client.publish_deposition(id: id)
      return deposition
    rescue Zenodo::Errors::ClientError => e
      Rails.logger.error "Zenodo deposition publish failed: #{e.inspect}"
    end
    nil
  end
end