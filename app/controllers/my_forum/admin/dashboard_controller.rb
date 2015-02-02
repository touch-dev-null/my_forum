require_dependency "my_forum/application_controller"

module MyForum
  class Admin::DashboardController < ApplicationController

    layout 'layouts/my_forum/admin_application'

    def index
    end
  end
end
