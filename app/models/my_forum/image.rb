module MyForum
  class Image < ActiveRecord::Base
    belongs_to  :user
  end
end
