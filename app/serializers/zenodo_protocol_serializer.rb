class ZenodoProtocolSerializer
  include ActiveModel::Serialization

  def initialize(protocol:)
    @protocol = protocol
  end

  def as_json
    attributes
  end

  def to_json
    as_json.to_json
  end

  def attributes
    {
      'metadata' => {
        'title' => @protocol.title,
        'upload_type' => 'publication',
        'publication_type' => 'article',
        'description' => @protocol.description,
        'creators' =>[{'name' => 'sprotocols', 'affiliation' => 'ScientificProtocols.org'}]
      }
    }
  end
end