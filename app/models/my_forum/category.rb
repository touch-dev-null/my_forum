module MyForum
  class Category < ActiveRecord::Base
    has_many :forums
  end
end
