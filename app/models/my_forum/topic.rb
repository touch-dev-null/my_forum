module MyForum
  class Topic < ActiveRecord::Base
    has_many  :posts
    belongs_to  :forum
  end
end
