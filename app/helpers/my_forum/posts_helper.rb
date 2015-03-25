module MyForum
  module PostsHelper
    def format_post_text(post)
      format_bbcode(post.text)
    end

    def format_bbcode(text)
      # Images
      text.gsub!(/\[img\]/i,   '<img src="')
      text.gsub!(/\[\/img\]/i, '" />')

      # Bold text
      text.gsub!(/\[b\]/i,   '<strong>')
      text.gsub!(/\[\/b\]/i, '</strong>')

      text.gsub!(/\[i\]/i,   '<i>')
      text.gsub!(/\[\/i\]/i, '</i>')

      # Cut
      text.gsub!(/\[cut\]/i,   '<pre>')
      text.gsub!(/\[\/cut\]/i, '</pre>')

      # Color
      text.gsub!(/\[color=(.*?)\](.*?)\[\/color\]/i) { "<span style='color: #{$1}'>#{$2}</span>" }

      # Size
      text.gsub!(/\[size=(.*?)\](.*?)\[\/size\]/i) { "<span style='font-size: #{$1}'>#{$2}</span>" }

      # Quote
      text.gsub!(/\[quote author=(.*?) link=(.*?) date=(.*?)\]/i) { bbquote(author: $1, date: $3) }
      text.gsub!(/\[\/quote\]/i, '</div>')

      # Link
      text.gsub!(/\[url=(.*?)\](.*?)\[\/url\]/i) { "<a href='#{$1}'>#{$2}</a>" }

      text.html_safe
    end

    def bbquote(author:, date:)
      date_time = DateTime.strptime(date, '%s') rescue ''
      "<div class='bbqoute'><strong>#{author}</strong> #{date_time}: "
    end
  end
end
