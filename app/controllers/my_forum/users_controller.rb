require_dependency "my_forum/application_controller"

module MyForum
  class UsersController < ApplicationController

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      if @user.valid?
        @user.user_groups << UserGroup::MEMBER_GROUP
        @user.save
        session[:user_id] = @user.id
        redirect_to root_path
      else
        render :new
      end
    end

    def signin
      if request.post?
        if params[:user].blank?
          render :layout => 'signin'
          return
        end

        user = User.find_by_login(params[:user][:login])
        if user && user.valid_password?(params[:user][:password])
          session[:user_id] = user.id
          redirect_to root_path
          return
        else
          flash[:error] = t('.invalid_login_or_password')
          return
        end
      end
    end

    def forgot_password
      if request.post?
        return unless user = User.find_by_email(params[:user][:email])
        UserMailer.reset_password_email(user).deliver_now
        redirect_to root_path
      end
    end

    def logout
      session[:user_id] = nil
      redirect_to admin_root_path
    end

    private

    def user_params
      params.require(:user).permit(:login, :email, :password)
    end

  end
end
