module MyForum
  module TopicsHelper

    def topic_last_post_info(topic)
      post = topic.posts.last

      html  = content_tag(:div, post.created_at)
      html += content_tag(:div,post.user.login)
      html.html_safe
    end

    def draw_navigation(topic)
      html_li  = content_tag :li, link_to('Forums', root_path)
      html_li += content_tag :li, '&rarr;'.html_safe
      html_li += content_tag :li, link_to(topic.forum.name, forum_path(topic.forum))

      html = content_tag :ul, class: 'draw-navigation' do
        html_li
      end

      html.html_safe
    end

  end
end
