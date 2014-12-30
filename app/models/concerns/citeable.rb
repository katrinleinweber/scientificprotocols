# Adds methods for dealing with citations to any ActiveRecord model.
module Citeable
  extend ActiveSupport::Concern

  def citation_url
    return nil if self.doi.blank?
    "http://dx.doi.org/#{self.doi}"
  end

  def doi_badge
    return nil if self.doi.blank?
    "\n\n[![DOI](https://zenodo.org/badge/doi/#{self.doi}.svg)](#{self.citation_url})"
  end
end