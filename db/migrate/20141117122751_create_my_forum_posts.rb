class CreateMyForumPosts < ActiveRecord::Migration
  def change
    create_table :my_forum_posts do |t|
      t.integer :user_id
      t.integer :topic_id
      t.text    :text
      t.timestamps
    end
  end
end
