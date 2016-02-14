require_dependency "my_forum/application_controller"

module MyForum
  class PostsController < ApplicationController
    before_filter :verify_admin, only: [:edit, :update]
    before_filter :find_topic, except: [:show, :preview]
    before_filter :find_forum, except: [:show, :preview]

    include PostsHelper

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

    def edit
      @forum  = Forum.find(params[:forum_id])
      @topic  = Topic.find(params[:topic_id])
      @post   = Post.find(params[:id])
    end

    def update
      post = Post.find(params[:id])
      post.text       = params[:post][:text]
      post.edited_by  = current_user.login
      post.save

      redirect_to forum_topic_path(post.topic.forum, post.topic, page: params[:page])
    end

    def preview
      preview_html = ActionController::Base.helpers.sanitize format_bbcode(params[:text])
      render '/my_forum/shared/post_preview.js.coffee', layout: false, locals: { preview_html: preview_html }
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
