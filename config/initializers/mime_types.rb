# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
Mime::Type.register 'text/x-markdown', :markdown

# http://stackoverflow.com/a/13655847/880381
markdown_mime_type = MIME::Type.new('text/x-markdown') do |t|
  t.extensions  = %w(md)
end

MIME::Types.add markdown_mime_type
