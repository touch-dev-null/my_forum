class CreateMyForumCategories < ActiveRecord::Migration
  def change
    create_table :my_forum_categories do |t|
      t.string  :name
      t.timestamps null: false
    end
  end
end
