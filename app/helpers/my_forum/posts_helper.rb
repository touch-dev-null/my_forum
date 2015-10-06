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
      text.gsub!(/(\[b\])(?<bold_text>.*)(\[\/b\])/i) { |match| "<strong>#{$1}</strong>" }

      # Italic
      text.gsub!(/(\[i\])(?<italic_text>.*)(\[\/i\])/i) { |match| "<i>#{$1}</i>" }

      # Cut
      text.gsub!(/(\[cut\])(?<cut_text>.*)(\[\/cut\])/i) { |match| "<pre>#{$1}</pre>" }

      # Color
      text.gsub!(/\[color=(.*?)\](.*?)\[\/color\]/i) { "<span style='color: #{$1}'>#{$2}</span>" }

      # Size
      text.gsub!(/\[size=(.*?)\](.*?)\[\/size\]/i) { "<span style='font-size: #{$1}'>#{$2}</span>" }

      # Quote
      text.gsub!(/\[quote author=(.*?) link=(.*?) date=(.*?)\]/i) { bbquote(author: $1, date: $3) }
      text.gsub!(/\[\/quote\]/i, '</div>')
      text.gsub!(/\[quote(.*)\]/i, "<div class='bbqoute'>")

      # Link
      text.gsub!(/\[url=(.*?)\](.*?)\[\/url\]/i) { "<a href='#{$1}'>#{$2}</a>" }

      text.html_safe
    end

    def bbquote(author:, date:)
      date_time = time(DateTime.strptime(date, '%s')) rescue ''
      "<div class='bbqoute'> <div class='quote_info'>#{author} #{t('my_forum.bbquote.wrote')} #{date_time}:</div> "
    end
  end
end
