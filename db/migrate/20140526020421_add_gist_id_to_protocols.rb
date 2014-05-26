class AddGistIdToProtocols < ActiveRecord::Migration
  def change
    add_column :protocols, :gist_id, :string, null: false, after: :description
    add_index :protocols, :gist_id, unique: true
  end
end
