class MyForumRenameUserAvatar < ActiveRecord::Migration
  def change
    rename_column :my_forum_users, :avatar, :avatar_url
  end
end
