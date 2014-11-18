require_dependency "my_forum/application_controller"

module MyForum
  class ForumsController < ApplicationController
    before_filter :find_forum

    def show

    end

    private
    def find_forum
      @forum = Forum.find(params[:id])
    end
  end
end
