module MyForum
  class Topic < ActiveRecord::Base
    has_many  :posts, dependent: :destroy
    belongs_to  :forum, :counter_cache => true

    def info
      author  = (post = posts.first).user.login
      created = post.created_at

      { author: author, created: created }
    end

    def owner
      posts.first.user
    end
  end
end
