class CreateGroupAdmins < ActiveRecord::Migration[6.0]
  def change
    create_table :group_admins do |t|
      t.integer :group_id
      t.integer :admin_id

      t.timestamps
    end
  end
end
