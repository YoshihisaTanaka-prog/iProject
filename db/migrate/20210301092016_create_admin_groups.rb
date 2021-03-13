class CreateAdminGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :admin_groups do |t|
      t.string  :name
      t.boolean :isSpecial,      null: false, default: false
      t.integer :special_id

      t.timestamps
    end
  end
end
