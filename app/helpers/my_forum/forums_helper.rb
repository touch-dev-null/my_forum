module MyForum
  module ForumsHelper
    def forum_stat(forum)
      html = t('.topics_count', topics_count: forum.topics.count)
      html += '<br />'
      html += t('.messages_count', messages_count: forum.topics.count)
      html.html_safe
    end

    def forum_last_message_info(forum)
      html = t('.last_answer_from') + '<strong>Test_user</strong>'
      html += '<br />'
      html += t('.in_forum') + 'Re: Lada Vesta Concept W...'
      html += '<br />'
      html += '28 Октября 2014, 19:58:16'
      html.html_safe
    end
  end
end
