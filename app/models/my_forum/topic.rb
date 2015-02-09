module MyForum
  class Topic < ActiveRecord::Base
    has_many  :posts, :counter_cache => true, dependent: :destroy
    belongs_to  :forum, :counter_cache => true
    belongs_to  :user

    def info
      author  = (post = posts.first).user.login
      created = post.created_at

      { author: author, created: created }
    end

    def owner
      posts.first.user
    end

    def unread?(current_user, last_post)
      return true unless current_user

      log = LogReadMark.where(user_id: current_user.id, topic_id: self.id, post_id: last_post.id).count
      log >= 1 ? false : true
    end

    def mark_as_read(current_user, last_topic)
      return true unless current_user

      log = LogReadMark.find_or_create_by(user_id: current_user.id, topic_id: self.id)
      log.post_id = last_topic.id
      log.save
    end
  end
end
