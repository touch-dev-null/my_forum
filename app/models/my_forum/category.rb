module MyForum
  class Category < ActiveRecord::Base
    has_many :forums
    has_many :category_permission
    has_many :user_groups, through: :category_permission
  end
end
