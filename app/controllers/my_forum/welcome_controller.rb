require_dependency "my_forum/application_controller"

module MyForum
  class WelcomeController < ApplicationController
    def index
      @forum_categories = Category.includes(:forums).all
    end
  end
end
