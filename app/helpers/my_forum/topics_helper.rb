module MyForum
  module TopicsHelper

    def topic_last_post_info(topic)
      html  = content_tag(:div, forum_time(topic.last_post_time))
      html += content_tag(:div, topic.last_post_user_login)
      html.html_safe
    end

    def can_quick_answer?(forum)
      return false  unless current_user
      return true   if is_admin?
      return false  if forum.closed?
      true
    end

  end
end
