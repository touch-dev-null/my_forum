require_dependency "my_forum/application_controller"

module MyForum
  class UsersController < ApplicationController

    before_filter :authorize_user, only: [:edit, :update]

    def new
      @user = User.new
    end

    def edit
    end

    def update
      update_password
      current_user.update_columns(user_update_params)
      redirect_to edit_user_path(current_user)
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

    def authorize_user
      redirect_to root_path unless current_user
    end

    def autocomplete
      #TODO mysql safe
      search_string = params[:str]
      user_list = MyForum::User.where("login LIKE '%#{search_string}%'").pluck(:login)

      respond_to do |format|
        format.html { raise 'denied' }
        format.js { render json: user_list }
      end
    end

    private

    def user_params
      params.require(:user).permit(:login, :email, :password)
    end

    def user_update_params
      params.require(:user).permit(:email)
    end

    def update_password
      current_password = user_params.delete(:password)
      new_password = params[:user].delete(:new_password)

      return unless new_password
      return unless current_user.valid_password?(current_password)
      current_user.update_attributes(password: new_password)
    end

  end
end
