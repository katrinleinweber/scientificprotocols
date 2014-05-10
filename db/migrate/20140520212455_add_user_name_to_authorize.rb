class AddUserNameToAuthorize < ActiveRecord::Migration
  def change
    add_column :users, :username, :string, null: false, default: "", after: :id
  end
end
