class Service::WordToMarkdownManager
  ENCODED_IMAGE_REGEXP = Regexp.new(/(!\[\]\(data:image.+\))/)

  # Converts a word document to markdown
  # @param [String] filepath the path to the file (usually tempfile coming from upload).
  # @return [Service::WordToMarkdownManager] instance.
  def initialize(filepath:)
    @raw_markdown ||= WordToMarkdown.new(filepath).to_s
  end

  # Markdown string in optional raw format or processed format where images a stored on S3 and
  # replaced as links instead of encoded data.
  # @param [Boolean] raw specifies if the desired markdown format should be processed or not.
  # @return [String] markdown formatted string.
  def markdown(raw: false)
    return raw_markdown if raw
    process_encoded_images(markdown: raw_markdown, images: encoded_markdown_images)
  end

  # Processes encoded image strings and replaces them with links to S3 stored images.
  # @param [String] markdown raw markdown string
  # @param [Array] images an array of image strings with Base64 encoded data.
  # @return [String] markdown string where Base64 strings are replaced with links to S3 stored strings.
  private def process_encoded_images(markdown:, images:)
    images.each do |image_string|
      image_io = MarkdownImageInput.new(image_string)
      uploader = WordDocumentImageUploader.new
      uploader.store!(image_io)
      markdown.sub!(image_string, "![](#{uploader.url})")
    end
    markdown
  end

  private def raw_markdown
    @raw_markdown
  end

  private def uploader
    @uploader
  end

  private def encoded_markdown_images
    raw_markdown.scan(ENCODED_IMAGE_REGEXP).flatten
  end
end