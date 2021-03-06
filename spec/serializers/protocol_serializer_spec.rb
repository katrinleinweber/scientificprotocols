require 'spec_helper'

describe ProtocolSerializer, :timefreeze do
  let(:protocol_manager) { FactoryGirl.create(:protocol_manager) }
  let(:protocol) { protocol_manager.protocol }
  let(:serializer) { ProtocolSerializer.new(protocol) }
  it 'should serialize exposed attributes' do
    expected_data = {
      id: protocol.slug,
      url: api_v1_protocol_url(protocol, protocol: :https),
      title: protocol.title,
      description: protocol.description,
      gist_id: protocol.gist_id,
      html_url: protocol_url(protocol, protocol: :https),
      discussion_html_url: discussion_protocol_url(protocol, protocol: :https),
      tags: protocol.tags.map(&:name),
      average_rating: protocol.average_rating,
      number_of_ratings: protocol.ratings.size,
      doi: protocol.doi,
      citation_html_url: protocol.citation_html_url,
      author: {
        username: protocol_manager.user.username,
        html_url: user_url(protocol_manager.user, protocol: :https)
      },
      created_at: protocol.created_at,
      updated_at: protocol.updated_at
    }
    expect(serializer.as_json(root: false)).to eq(expected_data)
  end
end
