module MyForum
  module TopicsHelper

    def topic_last_post_info(topic)
      post = topic.posts.last

      html  = content_tag(:div, post.created_at)
      html += content_tag(:div,post.user.login)
      html.html_safe
    end

  end
end
