class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :username, use: :slugged
  # Include default devise modules. Others available are:
  # :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:github]
  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login
  has_many :protocol_managers
  has_many :protocols, through: :protocol_managers
  validates :username, uniqueness: { case_sensitive: false }, format: { with: /\A[a-zA-Z0-9]+\Z/ }, length: { minimum: 5, maximum: 20 }
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(['lower(username) = :value OR lower(email) = :value', { value: login.downcase }]).first
    else
      where(conditions).first
    end
  end
  # Find an existing user using credentials obtained from oAuth.
  # Create the user if they don't exist. Associate a current user
  # with a GitHub account if current user supplied.
  # @param [Hash] auth The authentication settings returned from GitHub.
  # @param [User] current_user The user to associate the GitHub account with.
  def self.from_omniauth(auth, current_user = nil)
    user = where(auth.slice(:provider, :uid)).first
    if user.nil?
      if current_user.nil?
        user = User.create(
          email: auth.info.email,
          username: get_unique_username(auth.info.nickname),
          password: Devise.friendly_token[0,20],
          uid: auth.uid,
          provider: auth.provider
        )
      else
        # Associate the GitHub account with the user.
        current_user.update_attributes(
          uid: auth.uid,
          provider: auth.provider
        )
        user = current_user
      end
    end
    user
  end
  def github_connected?
    return (self.provider == 'github' && self.uid.present?)
  end
  private

  # Ensure the username is unique if it came from oAuth.
  # @param [String] username The username we're making unique.
  # @return [String] The unique username.
  def self.get_unique_username(username)
    is_unique = User.find_by_username(username).blank?
    new_username = username
    counter = 1
    while is_unique == false do
      new_username = username + counter.to_s
      is_unique = User.find_by_username(new_username).blank?
      counter += 1
    end
    new_username
  end
end
