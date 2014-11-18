module MyForum
  class Topic < ActiveRecord::Base
    has_many  :posts, dependent: :destroy
    belongs_to  :forum
  end
end
