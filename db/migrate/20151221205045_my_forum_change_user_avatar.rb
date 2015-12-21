class MyForumChangeUserAvatar < ActiveRecord::Migration
  def change
    change_column :my_forum_users, :avatar_url, :text, length: 350
  end
end
