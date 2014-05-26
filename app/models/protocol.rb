class Protocol < ActiveRecord::Base
  extend FriendlyId
  before_create :create_gist
  before_update :update_gist
  before_destroy :destroy_gist
  friendly_id :title, use: :slugged
  validates :title, presence: true
  validates :description, presence: true
  searchable do
    text :title, boost: 5
    text :description
    time :created_at
    string :sort_title do
      title.downcase.gsub(/^(an?|the)\b/, '')
    end
  end
  self.per_page = 10
  private
  def create_gist
    gist = {
      description: self.title,
      public: true,
      files: {
        PROTOCOL_FILE_NAME => {
          content: self.description
        }
      }
    }
    gist = OCTOKIT_CLIENT.create_gist(gist)
    self.gist_id = gist.id
  end
  def update_gist
    gist = OCTOKIT_CLIENT.gist(self.gist_id)
    gist.description = self.title
    gist.files[PROTOCOL_FILE_NAME].content = self.description
    OCTOKIT_CLIENT.edit_gist(self.gist_id, gist)
  end
  def destroy_gist
    OCTOKIT_CLIENT.delete_gist(self.gist_id)
  end
end
