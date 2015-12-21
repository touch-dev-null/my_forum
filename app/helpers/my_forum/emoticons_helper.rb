module MyForum
  module EmoticonsHelper
    def emoticon_url_for(emoticon)
      File.join(Emoticon::URL, emoticon.file_name)
    end
  end
end