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
    octokit_client = Octokit::Client.new
    gist = {
      description: self.title,
      public: true,
      files: {
        'protocol.txt' => {
          content: self.description
        }
      }
    }
    gist = octokit_client.create_gist(gist)
    self.gist_id = gist.id
  end
  def update_gist
    octokit_client = Octokit::Client.new
    gist = octokit_client.gist(self.gist_id)
    gist.description = self.title
    gist.files['protocol.txt'].content = self.description
    octokit_client.edit_gist(self.gist_id, gist)
  end
  def destroy_gist
    octokit_client = Octokit::Client.new
    octokit_client.delete_gist(self.gist_id)
  end
end
