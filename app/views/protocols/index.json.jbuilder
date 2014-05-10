json.array!(@protocols) do |protocol|
  json.extract! protocol, :id, :title, :description
  json.url protocol_url(protocol, format: :json)
end
