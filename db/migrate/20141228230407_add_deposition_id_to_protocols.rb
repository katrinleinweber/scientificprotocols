class AddDepositionIdToProtocols < ActiveRecord::Migration
  def change
    add_column :protocols, :deposition_id, :string, after: :doi
    add_index :protocols, :deposition_id, unique: true
  end
end
