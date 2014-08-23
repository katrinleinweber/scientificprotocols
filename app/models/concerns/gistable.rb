# Adds methods for dealing with Gists to any ActiveRecord model.
module Gistable
  extend ActiveSupport::Concern
  included do
    attr_accessor :gist
  end
  def gist_revision_url
    return nil if self.gist.blank?
    self.gist.html_url + '/revisions'
  end
  def gist_embed_url
    return nil if self.gist.blank?
    self.gist.url + '.js'
  end
  def gist_embed_script
    return nil if self.gist.blank?
    '<script src="' + gist_embed_url + '"></script>'
  end
end