class CreateMyForumImages < ActiveRecord::Migration
  def change
    create_table :my_forum_images do |t|
      t.integer :user_id
      t.integer :post_id
      t.string  :file_name
      t.integer :file_size
      t.string  :type
      t.timestamps null: false
    end
  end
end
