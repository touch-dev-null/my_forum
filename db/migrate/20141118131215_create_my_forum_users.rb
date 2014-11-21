class CreateMyForumUsers < ActiveRecord::Migration
  def self.up
    create_table :my_forum_users do |t|
      t.string  :login
      t.string  :password
      t.string  :salt
      t.string  :email
      t.integer :posts_count
      t.boolean :is_admin, default: false
      t.boolean :is_moderator, default: false
      t.timestamps
    end

    MyForum::User.reset_column_information
    user = MyForum::User.new(login: 'admin', password: 'admin', email: 'admin@example.com')
    user.save
  end

  def self.down
    drop_table :my_forum_users
  end
end
