module MyForum
  class UserGroup < ActiveRecord::Base
    has_many :user_group_links
    has_many :users, through: :user_group_links

    has_many :category_permissions
    has_many :categories, through: :category_permissions

    GUEST_GROUP   = UserGroup.find(1)
    MEMBER_GROUP  = UserGroup.find(2)
  end
end
