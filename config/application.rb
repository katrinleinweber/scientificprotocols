require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Scientificprotocols
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Choice gem. Easy external settings.
    config.from_file 'settings.yml'

    config.assets.precompile += %w( application_footer.js jquery-ui.js jquery-ui.css disimprison.css)

    # Sets the config for sending emails via Postmark.
    config.action_mailer.delivery_method = :postmark
    config.action_mailer.postmark_settings = {api_key: Rails.configuration.api_postmark}

    # Use sass syntax.
    config.sass.preferred_syntax = :sass
  end
end
