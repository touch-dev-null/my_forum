require_dependency "my_forum/application_controller"

module MyForum
  class WelcomeController < ApplicationController
    def index
      return @forum_categories = Category.includes(:forums) if current_user && current_user.is_admin?

      @forum_categories = Category.includes(:forums, :user_groups).
          reject{|category| (category.user_groups.map(&:name) & (current_user_groups)).blank? }
    end
  end
end
