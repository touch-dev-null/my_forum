module MyForum
  module UsersHelper
    # Display title name dependent user posts count
    def user_title(user)
      #TODO
      t('.beginner')
    end

    # Display user avatar
    def user_avatar(user)
      image_tag('blank_avatar.png', class: 'user-avatar')
    end

    def user_posts_count(user)
      user.posts.count
    end
  end
end
