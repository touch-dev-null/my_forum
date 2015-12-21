module MyForum
  module ApplicationHelper

    def draw_navigation
      html_li  = content_tag :li, link_to('Forums', root_path)

      if @forum
        html_li += content_tag :li, '&rarr;'.html_safe
        html_li += content_tag :li, link_to(@forum.name, forum_path(@forum))
      end

      if @forum && @topic && !@topic.new_record?
        html_li += content_tag :li, '&rarr;'.html_safe
        html_li += content_tag :li, link_to(@topic.name.html_safe, forum_topic_path(@forum, @topic))
      end

      html = content_tag :ul, class: 'draw-navigation' do
        html_li
      end

      html.html_safe
    end

    def online_users
      User.online.pluck(:login).join(', ')
    end

    def today_was_users
      User.today_visited.pluck(:login).join(', ')
    end

    def errors_for(obj)
      return if obj.errors.blank?

      content_tag :div, obj.errors.full_messages.to_sentence, class: 'errors_for'
    end

    # TODO deprecate!
    def time(datetime)
      forum_time(datetime)
    end

    def upload_allowed_extensions
      Attachment::ALLOWED_FILE_EXTENSIONS
    end
  end
end
