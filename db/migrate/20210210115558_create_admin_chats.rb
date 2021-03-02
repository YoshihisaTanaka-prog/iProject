class CreateAdminChats < ActiveRecord::Migration[6.0]
  def change
    create_table :admin_chats do |t|
      t.integer       :autho_id
      t.integer       :group_id
      t.text          :message
      t.string        :url
      t.boolean       :is_read,      null: false, default: false

      t.timestamps
    end
  end
end
