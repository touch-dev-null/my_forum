module MyForum
  module ForumsHelper

    def forum_name(forum)
      html  = content_tag :strong, link_to(forum.name, forum_path(forum))
      html += content_tag :div, forum.description
      html.html_safe
    end

    def forum_stat(forum)
      html  = content_tag(:div, t('.topics_count', topics_count: forum.topics_count))
      html += content_tag(:div, t('.messages_count', messages_count: forum.topics_count))
      html.html_safe
    end

    def forum_last_message_info(forum)
      recent_topic = forum.topics.order(:updated_at).first
      post = recent_topic.posts.last if recent_topic

      html  = content_tag(:div, recent_topic ? (t('.last_answer_from') + post.user.login) : '-' )
      html += content_tag(:div, recent_topic ? (t('.in_forum') + recent_topic.name) : '-' )
      html += content_tag(:div, recent_topic ? post.updated_at : '-' )
      html.html_safe
    end
  end
end
