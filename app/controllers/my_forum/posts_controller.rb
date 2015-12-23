require_dependency "my_forum/application_controller"

module MyForum
  class PostsController < ApplicationController
    before_filter :find_topic, except: [:show]
    before_filter :find_forum, except: [:show]

    def create
      unless params[:post].fetch(:text).blank?
        post = @topic.posts.build(post_params)
        post.user = current_user
        post.save

        process_attachments(post)
      end

      last_page = (@topic.posts.count.to_f / Post::PER_PAGE).ceil
      last_page = 1 if last_page == 0
      redirect_to forum_topic_path(@forum, @topic, page: last_page, go_to_last_post: true)
    end

    def destroy
      post = Post.find(params[:id])
      post.update(is_deleted: true)
      redirect_to forum_topic_path(post.topic.forum, post.topic)
    end

    def show
      post = Post.find(params[:id])
      respond_to do |format|
        format.js { render json: { text: post.text, author: post.user.login }.as_json, status: :ok }
      end
    end

    private

    def process_attachments(post)
      return unless matches = post_params.to_s.match(/\[attachment=([0-9]+)\]/i)

      matches.captures.map(&:to_i).each do |attachment_id|
        attachment = Attachment.where(id: attachment_id).first
        attachment.update(post: post) if attachment and post.user == attachment.user
      end
    end

    def find_topic
      @topic = Topic.find(params[:topic_id])
    end

    def find_forum
      @forum = Forum.find(params[:forum_id])
    end

    def post_params
      params.require(:post).permit(:text)
    end
  end
end
