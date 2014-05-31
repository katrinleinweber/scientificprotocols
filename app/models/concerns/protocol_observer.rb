module ProtocolObserver
  extend ActiveSupport::Concern
  included do
    before_create :create_gist
    before_update :update_gist
    before_destroy :destroy_gist
  end
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