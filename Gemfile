source 'https://rubygems.org'
source 'https://rails-assets.org'
ruby '2.2.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'.
# TODO - Don't update to Rails 4.2 yet. Issue with tags on protool edit.
gem 'rails', '4.1.8'
gem 'responders'

# Use SCSS for stylesheets.
gem 'sass-rails', '~> 4.0.3'

# Use Uglifier as compressor for JavaScript assets.
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views.
gem 'coffee-rails', '~> 4.0.0'

# Use jquery as the JavaScript library.
gem 'jquery-rails'
gem 'jquery-ui-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder.
gem 'jbuilder', '~> 2.0'

# Provides non-blocking I/O methods for Ruby without raising exceptions on EAGAIN and EINPROGRESS.
gem 'kgio'

# Bootstrap fields.
gem 'bootstrap-sass'
gem 'bootstrap_form'
gem 'bootstrap_tokenfield_rails'
gem 'autoprefixer-rails'
gem 'will_paginate-bootstrap'

# Font awesome
gem 'font-awesome-rails'

# Authorization & Access control.
gem 'cancancan'
gem 'omniauth-github'

# Markdown.
gem 'redcarpet'

# HTML truncate.
gem 'truncate_html'

# Serializers.
gem 'active_model_serializers'

# Search.
gem 'sunspot_solr'
gem 'sunspot_rails'

# Pagination.
gem 'will_paginate'

# GitHub.
# TODO - Pinned at 3.5.2 until following resolved.
# Failure/Error: patch :update, id: protocol.id, protocol: { title: Faker::Lorem.sentence(5) }
# Octokit::BadRequest:
# PATCH https://api.github.com/gists/0dd5f33a1db45bfc6b40: 400 - Problems parsing JSON // See: https://developer.github.com/v3
gem 'octokit', '3.5.2'

# Treat API objects in similar way to ActiveRecord.
gem 'activeresource'

# SEO.
gem 'roboto'
gem 'friendly_id'
gem 'meta-tags'

# Email.
gem 'postmark-rails'

# Sitemap generation.
gem 'sitemap_generator'
gem 'aws-sdk'
gem 'carrierwave'
gem 'fog'

# Tagging.
gem 'acts-as-taggable-on'

# Caching.
gem 'memcachier'
gem 'dalli'

# Performance metrics.
gem 'newrelic_rpm'

# Choice gem. Easy external settings.
gem 'choices'

# State management.
gem 'workflow'

# Allow copying to clipboard.
gem 'zeroclipboard-rails'

# Digital Object Identifiers (DOIs).
gem 'zenodo'

# Use PostgreSQL as the database for Active Record.
gem 'pg'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', '~> 0.4.0'
end

group :development do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  # Expose your local webserver without messing with DNS and firewall settings.
  gem 'ngrok'
end

group :test, :development do
  gem 'thin'
  # Our testing framework.
  gem 'rspec-rails'
  # Preloads rails environment for faster tests.
  gem 'spork-rails'
  # Used for running tests automatically.
  gem 'guard-rspec'
  # Used alongside spork to preload tests automatically.
  gem 'guard-spork'
  # Create mock objects for testing.
  gem 'factory_girl_rails'
  # Used for generating fake data for tests.
  gem 'faker'
  # Custom matchers for rspec.
  gem 'shoulda'
end

group :production, :staging do
  # Use unicorn as the app server.
  gem 'unicorn-rails'
  # Enable static asset serving and logging on Heroku.
  gem 'rails_12factor'
  # Use compressed asset versions.
  gem 'heroku_rails_deflate'
end