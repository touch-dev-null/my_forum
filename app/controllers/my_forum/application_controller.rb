module MyForum
  class ApplicationController < ActionController::Base

    def authenticate_user!
      redirect_to admin_signin_path unless current_user
    end

    def current_user
      return session[:user_id].blank? ? nil : User.where(id: session[:user_id]).first
    end
    helper_method :current_user

    def current_user_id
      session[:user_id]
    end
    helper_method :current_user_id

  end
end
