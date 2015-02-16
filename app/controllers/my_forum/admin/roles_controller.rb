require_dependency "my_forum/application_controller"

module MyForum
  class Admin::RolesController < ApplicationController

    before_filter :verify_admin

    layout 'layouts/my_forum/admin_application'

    def index
      @roles = Role.all
    end

    def new
      @role = Role.new
    end

    def create
      @role = Role.new(role_params)
      @role.save
      redirect_to admin_roles_path
    end

    def edit

    end

    def update

    end

    private

    def role_params
      params.require(:role).permit(:name, :color)
    end
  end
end
