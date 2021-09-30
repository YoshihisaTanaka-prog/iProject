class CreateCollageStatuses < ActiveRecord::Migration[6.0]
  def change
    create_table :collage_statuses do |t|
      t.string :collage_name
      t.integer :status,          null: false, default: 0
      t.integer :creator_id,      null: false, default: -1
      t.integer :checker_id,      null: false, default: -1

      t.timestamps
    end
  end
end
