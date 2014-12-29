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

  # Add a file to a Zenodo deposition. This is required for publishing.
  # @param [String, Fixnum] deposition_id A deposition's ID.
  # @param [String] file_or_io The file or already open IO to upload.
  # @param [String] filename The name of the file (optional except when an IO).
  # @param [String] content_type The content type of the file (optional except when an IO).
  # @raise [ArgumentError] If the supplied params are blank.
  # @return [Zenodo::Resources::DepositionFile, nil] A Zenodo deposition file resource.
  def self.create_deposition_file(deposition_id:, file_or_io:, filename: '', content_type: '')
    raise ArgumentError, "Deposition ID cannot be blank" if deposition_id.blank?
    raise ArgumentError, "File cannot be blank" if file_or_io.blank?
    begin
      deposition_file = Zenodo.client.create_deposition_file(
        id: deposition_id,
        file_or_io: file_or_io,
        filename: filename,
        content_type: content_type
      )
      return deposition_file
    rescue Zenodo::Errors::ClientError => e
      Rails.logger.error "Zenodo file create failed: #{e.inspect}"
    end
    nil
  end

  # Publish a Zenodo deposition so we can get a DOI.
  # @param [String, Fixnum] deposition_id A deposition's ID.
  # @raise [ArgumentError] If the supplied deposition ID is blank.
  # @return [Zenodo::Resources::Deposition, nil] A Zenodo deposition resource.
  def self.publish_deposition(deposition_id:)
    raise ArgumentError, "Deposition ID cannot be blank" if deposition_id.blank?
    begin
      deposition = Zenodo.client.publish_deposition(id: deposition_id)
      return deposition
    rescue Zenodo::Errors::ClientError => e
      Rails.logger.error "Zenodo deposition publish failed: #{e.inspect}"
    end
    nil
  end
end