class CreateProtocolManagers < ActiveRecord::Migration
  def change
    create_table :protocol_managers do |t|
      t.belongs_to :user
      t.belongs_to :protocol
      t.timestamps
    end
  end
end
