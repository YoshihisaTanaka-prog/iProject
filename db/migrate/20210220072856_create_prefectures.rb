class CreatePrefectures < ActiveRecord::Migration[6.0]
  def change
    create_table :prefectures do |t|
      t.string :regionId
      t.string :objectId
      t.string :name

      t.timestamps
    end
  end
end
