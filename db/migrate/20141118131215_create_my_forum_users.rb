class CreateMyForumUsers < ActiveRecord::Migration
  def self.up
    create_table :my_forum_users do |t|
      t.string  :login
      t.string  :password
      t.string  :salt
      t.string  :real_name
      t.integer :gender
      t.date    :birthdate
      t.string  :signature
      t.string  :avatar
      t.string  :location
      t.string  :user_ip
      t.text    :additional_info
      t.string  :email
      t.integer :posts_count
      t.boolean :is_admin, default: false
      t.boolean :is_moderator, default: false
      t.boolean :is_deleted, default: false
      t.boolean :permanently_banned, default: false
      t.timestamps null: false
      t.timestamp :last_logged_in
    end

    MyForum::User.reset_column_information
    user = MyForum::User.new(login: 'admin', password: 'admin', is_admin: true, email: 'admin@example.com')
    user.save
  end

  def self.down
    drop_table :my_forum_users
  end
end