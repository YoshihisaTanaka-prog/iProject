class CreateCaLists < ActiveRecord::Migration[6.0]
  def change
    create_table :ca_lists do |t|
      
      t.string  :controller_name  null: false default ""
      t.string  :action_name      null: false default ""
      t.boolean :is_only_subadmin null: false default false
      t.boolean :is_only_admin    null: false default false
      t.string  :path

      t.timestamps
    end
  end
end
