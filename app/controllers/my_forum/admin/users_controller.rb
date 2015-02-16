require_dependency "my_forum/application_controller"

module MyForum
  class Admin::UsersController < ApplicationController
    before_filter :verify_admin

    layout 'layouts/my_forum/admin_application'

    def index
      @users_count = User.count
      @user_groups = UserGroup.all
    end
  end
end
