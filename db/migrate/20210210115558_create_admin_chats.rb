class CreateAdminChats < ActiveRecord::Migration[6.0]
  def change
    create_table :admin_chats do |t|
      t.integer       :user_id
      t.text          :message
      t.boolean       :is_from_user
      t.boolean       :is_read,      null: false, default: false

      t.timestamps
    end
  end
end
