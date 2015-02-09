require_dependency "my_forum/application_controller"

module MyForum
  class UsersController < ApplicationController

    def new
      @user = User.new
    end

    def create
      @user = User.create(user_params)
      session[:user_id] = @user.id
      redirect_to root_path
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
          redirect_to admin_root_path
          return
        else
          flash[:error] = t('.invalid_login_or_password')
          return
        end
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
