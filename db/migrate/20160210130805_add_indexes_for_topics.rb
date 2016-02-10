class AddIndexesForTopics < ActiveRecord::Migration
  def change
    add_index :my_forum_topics, :latest_post_created_at,                        name: 'index_topics_latest_created_post'
    add_index :my_forum_topics, [:deleted, :latest_post_created_at],            name: 'index_topics_deleted_latest_created_post'
    add_index :my_forum_topics, [:pinned, :latest_post_created_at, :deleted],   name: 'index_topics_pinned_deleted_latest_created_post'
  end
end
