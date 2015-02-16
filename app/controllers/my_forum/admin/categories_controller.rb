require_dependency "my_forum/application_controller"

module MyForum
  class Admin::CategoriesController < ApplicationController

    before_filter :verify_admin

    layout 'layouts/my_forum/admin_application'

    def new
      @category = Category.new
    end

    def create
      @category = Category.new(category_params)
      @category.save ? redirect_to(admin_forums_path) : raise('category not created')
    end

    def edit
      @category = Category.find(params[:id])
      @user_groups = UserGroup.all
    end

    def update
      @category = Category.find(params[:id])
      @category.update_attributes(category_params)
      redirect_to edit_admin_category_path(@category)
    end

    protected

    def category_params
      params.require(:category).permit(:name, { :user_group_ids => [] })
    end
  end
end
