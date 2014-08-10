source 'https://rubygems.org'
ruby '2.1.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.4'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Provides non-blocking I/O methods for Ruby without raising exceptions on EAGAIN and EINPROGRESS.
gem 'kgio'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Bootstrap fields.
gem 'bootstrap-sass'
gem 'bootstrap_form'
gem 'bootstrap_tokenfield_rails'
gem 'autoprefixer-rails'

# Font awesome
gem 'font-awesome-rails'

# Authorization & Access control.
gem 'devise'
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
gem 'octokit'

# Treat API objects in similar way to ActiveRecord.
gem 'activeresource'

# SEO.
gem 'roboto'
gem 'friendly_id'

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
  # Use sql light in development and test.
  gem 'sqlite3'
end

group :production, :staging do
  # Use unicorn as the app server
  gem 'unicorn-rails'
  # Enable static asset serving and logging on Heroku
  gem 'rails_12factor'
  # Use compressed asset versions
  gem 'heroku_rails_deflate'
  # Use PostgreSQL as the database for Active Record.
  gem 'pg'
end