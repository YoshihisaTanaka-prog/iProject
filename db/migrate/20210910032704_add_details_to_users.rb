class AddDetailsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :parameter_id, :string, null: false, default: ""
    add_column :users, :domain, :string, null: false, default: ""
    add_column :users, :last_sent_time, :datetime, null: false, default: DateTime.now
    add_column :users, :unread_count, :integer, null: false, default: 0
  end
end
