require_dependency "my_forum/application_controller"

module MyForum
  class ForumsController < ApplicationController
    before_filter :find_forum, only: [:show]

    def show
      check_access_permissions(@forum)
      @forum_topics = @forum.topics_with_latest_post_info(page: params[:page], per_page: 30)
    end

    def unread_topics
      redirect_to root_path and return unless current_user
      @forum_topics = Forum.unread_topics_with_latest_post_info(user_id: current_user_id, page: params[:page], per_page: 30)

      render action: :show
    end

    def mark_all_as_read
      redirect_to root_path and return unless current_user

      Topic.find_in_batches(batch_size: 500) do |topic_group|
        topic_group.each do |topic|
          log = LogReadMark.find_or_create_by(user_id: current_user.id, topic_id: topic.id)
          log.post_id = topic.posts.last.id
          log.save
        end
      end

      redirect_to root_path
    end

    private

    def find_forum
      @forum = Forum.find(params[:id])
    end
  end
end
