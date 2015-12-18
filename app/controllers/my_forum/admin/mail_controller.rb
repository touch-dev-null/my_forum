require_dependency "my_forum/application_controller"

module MyForum
  class Admin::MailController < ApplicationController
    before_filter :verify_admin

    layout 'layouts/my_forum/admin_application'

    def index
      if request.post?
        send_mails(params[:emails], params[:subject], params[:message]) unless params[:emails].blank?
        redirect_to admin_mail_list_path
      else
        @users = User.all.map{ |u| [u.login, u.email]}
      end
    end

    private

    def send_mails(email_list, subject, message)
      email_list.each do |mail|
        begin
          UserMailer.custom_email(email: mail, subject: subject, message: message).deliver_now
        rescue => e
          logger.error '============= send_mails Mailer ============='
          logger.error e
        end
      end
    end
  end
end
