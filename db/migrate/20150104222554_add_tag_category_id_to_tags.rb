class AddTagCategoryIdToTags < ActiveRecord::Migration
  def change
    change_table :tags do |t|
      t.belongs_to :tag_category, after: :name
    end
  end
end
