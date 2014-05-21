class AddSlugToUsers < ActiveRecord::Migration
  def change
    add_column :users, :slug, :string, null: false, after: :last_sign_in_ip
    add_index :users, :slug, unique: true
  end
end
