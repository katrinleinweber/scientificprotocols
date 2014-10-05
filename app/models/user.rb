class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :username, use: :slugged
  has_many :protocol_managers
  has_many :protocols, through: :protocol_managers
  validates :username, uniqueness: { case_sensitive: false }, format: { with: /\A[a-zA-Z0-9]+\Z/ }, length: { minimum: 5, maximum: 20 }
  validates :email, uniqueness: { case_sensitive: false }, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  attr_accessor :octokit_client
  # Find an existing user using credentials obtained from oAuth. Create the user if they don't exist.
  # @param [Hash] auth The authentication settings returned from GitHub.
  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.email = auth.info.email
      user.username = auth.info.nickname
      user.provider = auth.provider
      user.uid = auth.uid
    end
  end
end
