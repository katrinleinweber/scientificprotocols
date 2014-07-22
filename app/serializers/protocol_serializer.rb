class ProtocolSerializer < ActiveModel::Serializer
  attributes :slug, :title, :description, :gist_id, :created_at, :updated_at, :tags
  def tags
    object.tags
  end
end