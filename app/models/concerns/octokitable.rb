# Attach an octokit client to any Active Record model.
module Octokitable
  extend ActiveSupport::Concern
  included do
    attr_accessor :octokit_client
  end
  # Set the current octokit client instance.
  # @param [String] access_token The authorization token for the current user obtained from GitHub.
  # @param [Hash] options A hash of options for the method.
  def set_octokit_client(access_token, options = {})
    options.reverse_merge(use_default_token: false)
    return if access_token.blank? && !options[:use_default_token]
    access_token ||= Rails.configuration.api_github
    self.octokit_client = Octokit::Client.new(access_token: access_token)
  end
end