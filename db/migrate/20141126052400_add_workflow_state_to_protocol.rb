class AddWorkflowStateToProtocol < ActiveRecord::Migration
  def change
    add_column :protocols, :workflow_state, :string, after: :description
    Protocol.update_all(workflow_state: 'published')
  end
end