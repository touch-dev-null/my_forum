module MyForum
  class Emoticon < ActiveRecord::Base
    UPLOAD_PATH = File.join(Rails.public_path, 'uploads', 'emoticons')
    URL = File.join('/uploads', 'emoticons')
  end
end
