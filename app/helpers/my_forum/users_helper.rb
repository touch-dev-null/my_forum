module MyForum
  module UsersHelper
    # Display title name dependent user posts count
    def user_title(user)
      #TODO
      t('.beginner')
    end

    # Display user avatar
    def user_avatar(user)
      return image_tag(user.avatar_url, class: 'user-avatar') unless user.avatar_url.blank?

      image_tag('blank_avatar.png', class: 'user-avatar')
    end

    def user_posts_count(user)
      user.posts_count
    end

    def is_online_user?(user_login)
      User.online.pluck(:login).include?(user_login)
    end

    def online_user_marker(user_login)
      return unless User.online.pluck(:login).include?(user_login)
      content_tag :div, '&nbsp;'.html_safe, class: 'label label-success'
    end

    def additional_info_attrs
      MyForum::User::ADDITIONAL_INFO_ATTRS
    end
  end
end
