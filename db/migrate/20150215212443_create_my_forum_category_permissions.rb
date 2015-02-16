class CreateMyForumCategoryPermissions < ActiveRecord::Migration
  def change
    create_table :my_forum_category_permissions do |t|
      t.integer :user_group_id
      t.integer :category_id
      t.timestamps null: false
    end
  end
end
