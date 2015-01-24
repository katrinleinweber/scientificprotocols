require 'spec_helper'

describe ZenodoProtocolSerializer, :timefreeze do
  let(:protocol_manager) { FactoryGirl.create(:protocol_manager) }
  let(:protocol) { protocol_manager.protocol }
  let(:serializer) { ZenodoProtocolSerializer.new(protocol: protocol) }
  it 'should serialize exposed attributes' do
    html = MARKDOWN.render(protocol.description).html_safe
    fragment = Nokogiri::HTML.fragment(html, encoding = nil)
    description = fragment.css('p').first.to_html
    expected_data = {
      'metadata' => {
        'title' => protocol.title,
        'upload_type' => 'publication',
        'publication_type' => 'article',
        'description' => description,
        'creators' => [{'name' => 'sprotocols', 'affiliation' => 'ScientificProtocols.org'}]
      }
    }
    expect(serializer.as_json).to eq(expected_data)
  end
end
