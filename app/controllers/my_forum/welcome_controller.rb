require_dependency "my_forum/application_controller"

module MyForum
  class WelcomeController < ApplicationController
    def index
      @forums = Forum.all
    end
  end
end
