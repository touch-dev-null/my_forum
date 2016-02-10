module MyForum
  module ForumsHelper

    def forum_status_img(forum)
      unread  = 'lada_logo_unread.jpg'
      read    = 'lada_logo.jpg'

      display_as = read
      display_as = unread if forum.has_unread_posts?(current_user)

      image_tag(display_as, width: '66px')
    end

    def forum_name(forum)
      html  = content_tag :strong, link_to(forum.name, forum_path(forum))
      html += content_tag :div, forum.description
      html.html_safe
    end

    def forum_stat(forum)
      html  = content_tag(:div, t('.topics_count', topics_count: forum.topics_count))
      html += content_tag(:div, t('.messages_count', messages_count: forum.posts_count))
      html.html_safe
    end

    def forum_last_message_info(forum)
      topic = forum.topics.order('latest_post_created_at DESC').first

      html  = content_tag(:div, topic ? (t('.last_answer_from') + topic.latest_post_login) : '-' )
      html += content_tag(:div, topic ? (link_to((t('.in_forum') + topic.name), forum_topic_path(topic.forum_id, topic.id))) : '-' )
      html += content_tag(:div, topic ? forum_time(topic.latest_post_created_at) : '-' )

      html.html_safe
    end

    def new_topic_button
      return unless current_user
      return unless @forum
      content_tag :div, class: 'buttons_for_new_topic' do
        link_to t('my_forum.create_new_topic'), new_forum_topic_path(@forum), class: 'btn btn-primary'
      end
    end
  end
end
