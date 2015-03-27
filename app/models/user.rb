class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :username, use: :slugged
  include Octokitable
  has_many :protocol_managers
  has_many :protocols, through: :protocol_managers
  has_many :ratings
  validates :username, uniqueness: { case_sensitive: false }, format: { with: /\A[-a-zA-Z0-9]+\Z/ }, length: { minimum: 1, maximum: 39 }
  validates :email, uniqueness: { case_sensitive: false }, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  attr_accessor :octokit_client

  # Find an existing user using credentials obtained from oAuth. Create the user if they don't exist.
  # @param [Hash] auth The authentication settings returned from GitHub.
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.username = auth.info.nickname
      user.provider = auth.provider
      user.uid = auth.uid
    end
  end

  # Get a list of protocols that the user has starred.
  # @param [Hash] params A hash of options for the method.
  def starred_protocols(params:)
    params.reverse_merge!({ page: 1 })
    gists = self.octokit_client.starred_gists(per_page: GITHUB_MAX_PAGE_SIZE)
    last_response = self.octokit_client.last_response
    if last_response.present?
      number_of_pages = self.number_of_pages(last_response)
      if number_of_pages > 1
        page_count = 2
        while page_count <= number_of_pages do
          gists += self.octokit_client.starred_gists(page: page_count, per_page: GITHUB_MAX_PAGE_SIZE)
          page_count += 1
        end
      end
    end
    @protocols = Protocol.where(gist_id: gists.map(&:id)).paginate(page: params[:page])
  end
end
