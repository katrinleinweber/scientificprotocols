module ProtocolObserver
  extend ActiveSupport::Concern
  included do
    before_create :before_create, if: lambda { !self.skip_callbacks }
    before_update :before_update, if: lambda { !self.skip_callbacks }
    before_destroy :before_destroy, if: lambda { !self.skip_callbacks }
  end

  private
  def before_create
    create_gist
    create_and_publish_deposition
  end

  def before_update
    update_gist
  end

  def before_destroy
    destroy_gist
  end

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

  def create_and_publish_deposition
    deposition_attributes = ZenodoProtocolSerializer.new(protocol: self).as_json
    deposition = Service::DepositionManager.create_deposition(deposition: deposition_attributes)
    if deposition.present?
      deposition = Service::DepositionManager.publish_deposition(id: deposition['id'])
      self.doi = deposition['doi'] unless deposition.blank?
    end
  end
end