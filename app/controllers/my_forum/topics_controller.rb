require_dependency "my_forum/application_controller"

module MyForum
  class TopicsController < ApplicationController
    before_filter :find_forum, only: [:new, :create, :show]

    def new
      @topic = @forum.topics.build
    end

    def show
      @topic = Topic.find(params[:id])
    end

    def create
      raise unless current_user
      #TODO !
      topic = @forum.topics.build(topic_params)
      post  = topic.posts.build(post_params)
      post.user = current_user

      topic.save
      post.save
      redirect_to forum_path(@forum)
    end

    private

    def find_forum
      @forum = Forum.find(params[:forum_id])
    end

    def topic_params
      params.require(:topic).permit(:name, :description)
    end

    def post_params
      params.require(:post).permit(:text)
    end
  end
end
