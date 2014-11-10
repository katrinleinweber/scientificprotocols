class AddDoiToProtocols < ActiveRecord::Migration
  def change
    add_column :protocols, :doi, :string, after: :gist_id
    add_index :protocols, :doi, unique: true
  end
end
