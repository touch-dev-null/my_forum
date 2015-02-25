module MyForum
  class UserGroup < ActiveRecord::Base
    has_many :user_group_links
    has_many :users, through: :user_group_links

    has_many :category_permissions
    has_many :categories, through: :category_permissions

    # TODO fix this
    GUEST_GROUP   = UserGroup.find_by_name('Guest') #find(1)
    MEMBER_GROUP  = UserGroup.find_by_name('Member') #.find(2)
  end
end
