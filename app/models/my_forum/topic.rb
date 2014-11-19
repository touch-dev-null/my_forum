module MyForum
  class Topic < ActiveRecord::Base
    has_many  :posts, dependent: :destroy
    belongs_to  :forum

    def info
      author  = (post = posts.first).user.login
      created = post.created_at

      { author: author, created: created }
    end
  end
end
