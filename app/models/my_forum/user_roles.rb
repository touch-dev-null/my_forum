module MyForum
  class UserRoles < ActiveRecord::Base
    belongs_to :user
    belongs_to :role
  end
end
