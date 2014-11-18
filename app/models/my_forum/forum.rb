module MyForum
  class Forum < ActiveRecord::Base
    belongs_to :category
    has_many  :topics
  end
end
