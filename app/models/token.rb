class Token < ActiveRecord::Base
  belongs_to :user
  before_create :generate_access_token

  validates :token, :user, presence: true

  scope :for_user, ->(user) { where(user_id: user.id) }
  
  def generate_access_token
    begin
      self.token = SecureRandom.hex
    end while self.class.exists?(token: self.token)
  end
  private :generate_access_token
end
