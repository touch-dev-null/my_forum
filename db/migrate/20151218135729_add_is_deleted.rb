class AddIsDeleted < ActiveRecord::Migration
  def change
    add_column :my_forum_posts, :is_deleted, :boolean, default: false
    add_column :my_forum_topics, :is_deleted, :boolean, default: false
  end
end
