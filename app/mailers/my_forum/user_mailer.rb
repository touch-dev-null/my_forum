module MyForum
  class UserMailer < ApplicationMailer
    def reset_password_email(user)
      @user = user

      o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
      @new_password = (0...10).map { o[rand(o.length)] }.join

      @user.password = @new_password
      @user.save
      mail(to: @user.email, subject: 'vaz.od.ua - New password')
    end

    def custom_email(email:, subject:, message:)
      @message = message
      mail(to: email, subject: subject)
    end

    def pm_notification(user, sender)
      @sender = sender
      mail(to: user.email, subject: I18n.t('my_forum.mailer.new_pm_notification_subject'))
    end
  end
end
