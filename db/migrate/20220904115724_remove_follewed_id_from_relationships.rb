class RemoveFollewedIdFromRelationships < ActiveRecord::Migration[6.1]
  def change
    remove_column :relationships, :follewed_id, :integer
  end
end
