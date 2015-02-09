require_dependency "my_forum/application_controller"

module MyForum
  class ForumsController < ApplicationController
    before_filter :find_forum, only: [:show]

    def show
      @forum_topics = @forum.topics.order(:updated_at).paginate(:page => params[:page], :per_page => 30)
    end

    def unread_topics
      redirect_to root_path and return unless current_user

      log_topic_ids = LogReadMark.where(user_id: current_user.id).pluck(:topic_id)
      @forum_topics = Topic.where('id NOT IN (?)', log_topic_ids).order(:updated_at).paginate(:page => params[:page], :per_page => 30)

      render action: :show
    end

    def mark_all_as_read
      redirect_to root_path and return unless current_user

      Topic.find_in_batches(batch_size: 500) do |topic_group|
        topic_group.each do |topic|
          log = LogReadMark.find_or_create_by(user_id: current_user.id, topic_id: topic.id)
          #binding.pry
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
