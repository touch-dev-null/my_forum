class CreateMyForumPosts < ActiveRecord::Migration
  def change
    create_table :my_forum_posts do |t|
      t.integer :user_id
      t.integer :topic_id
      t.integer :forum_id
      t.text    :text,    :limit => 4294967295
      t.timestamps null: false
    end
  end
end
