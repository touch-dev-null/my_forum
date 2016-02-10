require_dependency "my_forum/application_controller"

module MyForum
  class TopicsController < ApplicationController
    before_filter :find_forum,      only: [:new, :create, :show]
    before_filter :check_is_admin,  only: [:pin, :close, :delete]

    def new
      @topic = @forum.topics.build
    end

    def show
      @topic = Topic.find(params[:id])
      check_access_permissions(@topic)

      user_last_page = get_last_readed_user_page

      @topic_posts  = @topic.posts.includes(:user, :topic).paginate(per_page: Post::PER_PAGE, page: (params[:page] || user_last_page))
      @new_post = Post.new #TODO if quick_answer_enabled

      @topic.mark_as_read(current_user, @topic_posts.last)
      @topic.increment!(:views) if current_user
    end

    def create
      raise unless current_user
      #TODO !
      topic = @forum.topics.build(topic_params)
      post  = topic.posts.build(post_params)
      post.user = current_user

      topic.save
      post.save

      topic.mark_as_read(current_user, post)

      redirect_to forum_path(@forum)
    end

    def pin
      return unless topic = Topic.find_by_id(params[:topic_id])
      topic.toggle!(:pinned)

      redirect_to forum_topic_path(topic.forum, topic)
    end

    def close
      return unless topic = Topic.find_by_id(params[:topic_id])
      topic.toggle!(:closed)

      redirect_to forum_topic_path(topic.forum, topic)
    end

    def delete
      return unless topic = Topic.find_by_id(params[:topic_id])
      topic.update!(deleted: true)

      redirect_to forum_path(topic.forum)
    end

    private

    # TODO development in progress
    def get_last_readed_user_page
      return nil if current_user.blank?
      return nil unless params[:page].blank?
      user_last_page = nil

      latest_readed_post = LogReadMark.where(user_id: current_user.id, topic_id: @topic.id).first
      return nil unless latest_readed_post

      page_groups = @topic.posts.pluck(:id).in_groups_of(Post::PER_PAGE)
      page_groups.each_with_index { |group, page| user_last_page = page and break if group.include?(latest_readed_post.post_id) }
      user_last_page +=1 if user_last_page

      user_last_page
    end

    def check_is_admin
      return unless current_user
      return unless current_user.is_admin?
    end

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
