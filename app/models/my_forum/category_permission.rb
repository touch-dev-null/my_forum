module MyForum
  class CategoryPermission < ActiveRecord::Base
    belongs_to :category
    belongs_to :user_group
  end
end
