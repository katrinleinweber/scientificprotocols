class Tag < ActsAsTaggableOn::Tag
  belongs_to :tag_category, touch: true
end