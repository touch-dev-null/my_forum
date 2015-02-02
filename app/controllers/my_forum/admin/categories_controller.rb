require_dependency "my_forum/application_controller"

module MyForum
  class Admin::CategoriesController < ApplicationController

    layout 'layouts/my_forum/admin_application'

    def new
      @category = Category.new
    end

    def create
      @category = Category.new(category_params)
      @category.save ? redirect_to(admin_forums_path) : raise('category not created')
    end

    protected

    def category_params
      params.require(:category).permit(:name)
    end
  end
end
