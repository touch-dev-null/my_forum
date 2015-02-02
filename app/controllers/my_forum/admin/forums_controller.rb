require_dependency "my_forum/application_controller"

module MyForum
  class Admin::ForumsController < ApplicationController

    layout 'layouts/my_forum/admin_application'

    before_filter :find_category, only: [ :new, :create ]

    def index
      @categories = Category.all
    end

    def new
      @forum = @forum_category.forums.build
    end

    def create
      @forum = @forum_category.forums.build(forum_params)
      @forum.save ? redirect_to(admin_forums_path) : raise('forum not created')
    end

    protected

    def find_category
      @forum_category = Category.find(params[:category_id])
    end

    def forum_params
      params.require(:forum).permit(:name, :description)
    end
  end
end
