class CreateRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :relationships do |t|

      t.integer :follower_id
      t.integer :follewed_id
      
      t.timestamps
    end
  end
end
