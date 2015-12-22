module MyForum
  class Forum < ActiveRecord::Base
    belongs_to :category
    has_many  :topics
    has_many  :posts

    def latest_topic_info
      Topic.find_by_sql("
        SELECT
          my_forum_topics.name AS topic_name,
          my_forum_topics.forum_id,
          my_forum_topics.id,
          my_forum_posts.created_at AS post_created_at,
          my_forum_users.login AS user_login
        FROM my_forum_posts
        JOIN my_forum_topics ON my_forum_topics.id = my_forum_posts.topic_id
        JOIN my_forum_users ON my_forum_posts.user_id = my_forum_users.id
        WHERE my_forum_topics.forum_id = #{self.id}
        ORDER BY my_forum_posts.id DESC
        LIMIT 1
      ").first
    end

    def has_unread_posts?(current_user)
      latest_post_ids = self.topics.where('updated_at >= ?', current_user.created_at).pluck(:latest_post_id)
      read_log = LogReadMark.where("user_id = ? AND post_id IN (?)", current_user.id, latest_post_ids).count

      latest_post_ids.length != read_log
    end

    def topics_with_latest_post_info(page: 0, per_page: 30)
      Topic.paginate_by_sql("
        SELECT my_forum_topics.*, my_forum_users.login AS last_post_user_login, my_forum_posts.created_at AS last_post_time
        FROM my_forum_topics
        JOIN my_forum_posts ON my_forum_posts.id = my_forum_topics.latest_post_id
        JOIN my_forum_users ON my_forum_posts.user_id = my_forum_users.id
        WHERE my_forum_topics.forum_id = #{self.id} AND my_forum_topics.deleted IS FALSE
        ORDER BY my_forum_posts.id DESC
      ", page: page, per_page: per_page)
    end

    def self.unread_topics_with_latest_post_info(user_id:, page: 0, per_page: 30)
      log_topic_ids = LogReadMark.where(user_id: user_id).pluck(:topic_id)
      log_topic_ids = [0] if log_topic_ids.empty?

      Topic.paginate_by_sql("
        SELECT my_forum_topics.*, my_forum_users.login AS last_post_user_login, my_forum_posts.created_at AS last_post_time
        FROM my_forum_topics
        JOIN my_forum_posts ON my_forum_posts.id = my_forum_topics.latest_post_id
        JOIN my_forum_users ON my_forum_posts.user_id = my_forum_users.id
        WHERE my_forum_topics.id NOT IN (#{log_topic_ids.join(',')}) AND my_forum_topics.deleted IS FALSE
        ORDER BY my_forum_posts.id DESC
      ", page: page, per_page: per_page)
    end

    def unread_topics_with_user
      log_topic_ids = LogReadMark.where(user_id: current_user.id).pluck(:topic_id)
      Topic.where('id NOT IN (?)', log_topic_ids).order('updated_at DESC').paginate(:page => params[:page], :per_page => 30)
    end
  end
end
