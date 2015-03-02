class CreateMyForumUserGroupLinks < ActiveRecord::Migration
  def change
    create_table :my_forum_user_group_links do |t|
      t.integer :user_id
      t.integer :user_group_id
      t.timestamps null: false
    end
  end
end
