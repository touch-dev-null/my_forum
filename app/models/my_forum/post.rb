module MyForum
  class Post < ActiveRecord::Base
    belongs_to  :topic, :counter_cache => true
    belongs_to  :user, :counter_cache => true

    after_create :update_topic_latest_post
    after_update :update_topic_latest_post, :if => :is_deleted?

    default_scope { where(is_deleted: false) }

    PER_PAGE = 15

    private

    def update_topic_latest_post
      post = self.is_deleted ? Post.where(topic_id: self.topic_id).last : self

      self.topic.update(
        latest_post_id:         post.id,
        latest_post_created_at: post.created_at,
        latest_post_login:      post.user.login,
        latest_post_user_id:    post.user.id
      )
    end
  end
end
