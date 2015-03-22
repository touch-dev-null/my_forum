class CreateMyForumPrivateMessages < ActiveRecord::Migration
  def change
    create_table :my_forum_private_messages do |t|
      t.integer :sender_id
      t.string :sender_login
      t.integer :recipient_id
      t.string :recipient_login
      t.boolean :sender_deleted, :default => false
      t.boolean :recipient_deleted, :default => false
      t.boolean :unread, :default => true
      t.string :subject
      t.text :body
      t.timestamps null: false
    end
  end
end
