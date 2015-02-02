class CreateMyForumUserRoles < ActiveRecord::Migration
  def change
    create_table :my_forum_user_roles do |t|
      t.integer :user_id
      t.integer :role_id
      t.timestamps
    end
  end
end