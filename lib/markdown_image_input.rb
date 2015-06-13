class MarkdownImageInput < StringIO
  CONTENT_TYPE_REGEXP = Regexp.new(/data:(.+);/)
  # Initialize StringIO object with a few monkey-patches.
  # This object takes a markdown formatted string, not decoded stream data.
  # It does some markdown image specific things and hands it off to normal StringIO class.
  # @param [String] string of markdown flavored metadata and Base64 encoded image data.
  def initialize(string)
    meta_data, encoded_data = string.split(',')
    @meta_data ||= meta_data

    string = Base64.decode64(encoded_data)
    super
  end

  def meta_data
    @meta_data
  end

  def content_type
    meta_data.match(CONTENT_TYPE_REGEXP)[1]
  end

  def extension
    content_type.split('/').last
  end

  def original_filename
    "image.#{extension}"
  end
end