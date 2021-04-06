class CreateCaLimits < ActiveRecord::Migration[6.0]
  def change
    create_table :ca_limits do |t|
      
      t.integer :ca_list_id
      t.integer :admin_group_id

      t.timestamps
    end
  end
end
