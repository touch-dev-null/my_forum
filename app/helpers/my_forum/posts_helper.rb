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

      # Quote
      # text.gsub!(/\[quote.*]/i, '<span class="bbqoute">')
      # text.gsub!(/\[\/quote\]/i, '</span>')
      text.gsub!(/\[quote.*]/i, 'quote:')
      text.gsub!(/\[\/quote\]/i, '')

      # Link
      #text.scan(/(?<url>\[url=(.*?)\])(?<url_text>.*?)\[\/url\]/) {|m| puts m.first}
      #text.match(/(?<url>\[url=(.*?)\])(?<url_text>.*?)\[\/url\]/)
      #\[url=(.*?)\](.*?)\[\/url\]
      text.gsub!(/\[url=(.*?)\](.*?)\[\/url\]/i) { "<a href='#{$1}'>#{$2}</a>" }

      text.html_safe
    end
  end
end
