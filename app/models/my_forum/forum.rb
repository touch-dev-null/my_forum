module MyForum
  class Forum < ActiveRecord::Base
    belongs_to :category
    has_many  :topics
    has_many  :posts

    def latest_topic_info
      Topic.find_by_sql("
        SELECT my_forum_topics.name AS topic_name, my_forum_posts.created_at AS post_created_at, my_forum_users.login AS user_login
        FROM my_forum_topics
        JOIN my_forum_posts ON my_forum_posts.topic_id = my_forum_topics.id
        JOIN my_forum_users ON my_forum_topics.user_id = my_forum_users.id
        WHERE my_forum_topics.forum_id = #{self.id}
        ORDER BY my_forum_posts.id DESC
        LIMIT 1
      ").first
    end
  end
end
