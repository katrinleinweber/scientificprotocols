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
  end

  def before_update
    update_gist
  end

  def before_destroy
    destroy_gist
  end
end
