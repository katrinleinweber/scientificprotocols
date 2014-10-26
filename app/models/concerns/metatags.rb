module Metatags
  extend ActiveSupport::Concern

  OG_TAGS = [:title, :type, :image, :url, :description]
  KEYWORDS = ActsAsTaggableOn::Tag.all.map(&:name)

  included do
    append_before_filter :set_metatags
  end

  module ClassMethods
    def metatags(hash)
      @hash = hash
    end
  end

  private

  def set_metatags
    object = self.instance_variable_get("@#{self.class.to_s.underscore.split('_').first.singularize}")
    hash = self.class.instance_variable_get(:@hash)

    if object
      new_hash = {open_graph: {}}
      hash.each do |tag, method|
        value = object.send(method) if object.respond_to?(method)

        if tag == :keywords
          value = Array(value) + KEYWORDS
        elsif tag == :canonical
          value = self.send(method, object)
        end

        new_hash[tag] = value
        tag = :url if tag == :canonical
        new_hash[:open_graph][tag] = value if OG_TAGS.include?(tag)
      end
      set_meta_tags new_hash
    end
  end
end