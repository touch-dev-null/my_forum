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
      user.posts_count
    end

    def online_user_marker(user_login)
      return unless User.online.pluck(:login).include?(user_login)
      content_tag :div, '&nbsp;'.html_safe, class: 'label label-success'
    end
  end
end
