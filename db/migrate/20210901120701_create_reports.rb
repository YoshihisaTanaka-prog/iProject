class CreateReports < ActiveRecord::Migration[6.0]
  def change
    create_table :reports do |t|
      t.string :class_name
      t.string :object_id
      t.string :user_id

      t.timestamps
    end
  end
end
