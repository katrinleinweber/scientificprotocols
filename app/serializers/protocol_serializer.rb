class ProtocolSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :url, :title, :description, :gist_id, :html_url, :discussion_html_url,
    :tags, :average_rating, :number_of_ratings, :doi, :citation_html_url, :author,
    :created_at, :updated_at

  def id
    object.slug
  end

  def url
    api_v1_protocol_url(object, protocol: :https)
  end

  def html_url
    protocol_url(object, protocol: :https)
  end

  def discussion_html_url
    discussion_protocol_url(object, protocol: :https)
  end

  def tags
    object.tags.map(&:name)
  end

  def author
    build_author
  end

  def average_rating
    object.average_rating
  end

  def number_of_ratings
    object.ratings.size
  end

  private def build_author
    author = object.users.first
    if author.present?
      {
        username: author.username,
        html_url: user_url(author, protocol: :https)
      }
    else
      nil
    end
  end
end
