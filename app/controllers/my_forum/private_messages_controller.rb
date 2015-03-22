require_dependency "my_forum/application_controller"

module MyForum
  class PrivateMessagesController < ApplicationController

    before_filter :only_for_registered_users

    def index
      @private_messages = PrivateMessage.inbox_for(current_user)
      render :inbox
    end

    def inbox

    end

    def outbox

    end

    def deleted

    end

    def new
      @pm = PrivateMessage.new
      @reply_pm = PrivateMessage.find(params[:reply_for_id]) if params[:reply_for_id]
    end

    def create
      @pm = PrivateMessage.new
      recipient = begin
        User.find_by_login(params[:private_message].delete(:recipient))
      rescue
        #TODO send notification to admin
        nil
      end

      unless recipient
        @pm.errors.add(:base, t('.cant_find_recipient'))
        render :new
        return
      end

      @pm.recipient_id = recipient.id
      @pm.recipient_login = recipient.login
      @pm.sender_id = current_user_id
      @pm.sender_login = current_user.login
      @pm.assign_attributes(pm_params)
      @pm.save

      redirect_to action: :index
    end

    def show
      @pm = PrivateMessage.inbox_for(current_user).find(params[:id])
      @pm.update!(unread: false)
    end

    private

    def pm_params
      params.require(:private_message).permit(:subject, :body)
    end

    def only_for_registered_users
      redirect_to root_path unless current_user
    end
  end
end
