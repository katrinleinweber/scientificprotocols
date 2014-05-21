class AddSlugToProtocols < ActiveRecord::Migration
  def change
    add_column :protocols, :slug, :string, null: false, after: :description
    add_index :protocols, :slug, unique: true
  end
end
