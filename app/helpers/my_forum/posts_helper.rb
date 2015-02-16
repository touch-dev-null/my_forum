module MyForum
  module PostsHelper
    def format_post_text(post)
      text = post.text

      # Images
      text.gsub!(/\[img\]/,   '<img src="')
      text.gsub!(/\[\/img\]/, '" />')

      # Bold text
      text.gsub!(/\[b\]/,   '<strong>')
      text.gsub!(/\[\/b\]/, '</strong>')

      # Quote
      text.gsub!(/\[quote.*]/, '<span class="quote">')
      text.gsub!(/\[\quote\]/, '<\span>')

      text.html_safe
    end
  end
end
