# Configuration for the sitemap gem
# For documenation, see here:
# https://github.com/kjvarga/sitemap_generator

# To test sitemap generation, run:
# rake sitemap:refresh:no_ping

SitemapGenerator::Sitemap.default_host = 'https://protocols.scienceexchange.com'
SitemapGenerator::Sitemap.public_path = 'tmp/'

# Only upload to S3 in production
if Rails.env == 'production'
  SitemapGenerator::Sitemap.sitemaps_host = 'http://scientificprotocols.s3-website-us-east-1.amazonaws.com'
  SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'
  SitemapGenerator::Sitemap.adapter = SitemapGenerator::WaveAdapter.new
end

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end

  add '/', priority: 1.0, changefreq: 'daily'
  add protocols_path, priority: 0.9, changefreq: 'daily'
  add '/github', priority: 0.5, changefreq: 'weekly'

  Protocol.find_each do |protocol|
    add protocol_path(protocol), priority: 0.8, changefreq: 'weekly'
  end
end
