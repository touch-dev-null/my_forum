module MyForum
  class Topic < ActiveRecord::Base
    has_many    :posts, counter_cache: true, dependent: :destroy
    belongs_to  :forum, counter_cache: true
    belongs_to  :user

    default_scope { where(deleted: false) }

    def info
      author  = (post = posts.first).user.login
      created = post.created_at

      { author: author, created: created }
    end

    def owner
      posts.first.user
    end

    def unread?(current_user, last_post)
      return false unless current_user
      return false if current_user.created_at > last_post.created_at

      !LogReadMark.where(user_id: current_user.id, topic_id: self.id, post_id: last_post.id).present?
    end

    def mark_as_read(current_user, last_post)
      return true unless current_user

      log = LogReadMark.find_or_create_by(user_id: current_user.id, topic_id: self.id)

      if last_post.id.to_i > log.post_id.to_i
        log.post_id = last_post.id
        log.save
      end
    end
  end
end
