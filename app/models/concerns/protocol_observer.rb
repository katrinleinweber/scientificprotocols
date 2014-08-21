module ProtocolObserver
  extend ActiveSupport::Concern
  included do
    before_create :create_gist, if: lambda { !self.skip_callbacks }
    before_update :update_gist, if: lambda { !self.skip_callbacks }
    before_destroy :destroy_gist, if: lambda { !self.skip_callbacks }
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
    gist = self.octokit_client.create_gist(gist)
    self.gist_id = gist.id
  end
  def update_gist
    gist = self.octokit_client.gist(self.gist_id)
    gist.description = self.title
    gist.files[PROTOCOL_FILE_NAME].content = self.description
    self.octokit_client.edit_gist(self.gist_id, gist)
  end
  def destroy_gist
    self.octokit_client.delete_gist(self.gist_id)
  end
end