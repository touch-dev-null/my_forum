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

      current_user.update!(user_update_params)

      User::ADDITIONAL_INFO_ATTRS.each do |attr|
        current_user.update(attr => params[:user][attr]) if params[:user][attr]
      end

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

    def avatar_update
      if params[:user][:avatar]
        avatar = upload_avatar(params[:user][:avatar])
        current_user.update(avatar_url: File.join(Avatar::URL, current_user.id.to_s, avatar.file_name)) if avatar
      elsif params[:user][:avatar_url]
        current_user.update_columns(avatar_params)
      end

      redirect_to edit_user_path(current_user)
    end

    private

    def avatar_params
      params.require(:user).permit(:avatar_url)
    end

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

    def upload_avatar(avatar_param)
      return false unless Avatar::ALLOWED_FILE_CONTENT_TYPE.include? avatar_param.content_type

      current_avatar  = current_user.avatar
      upload_path     = File.join(Avatar::UPLOAD_PATH, current_user.id.to_s)

      # Create dir of not exists
      FileUtils::mkdir_p upload_path

      File.open(File.join(upload_path, avatar_param.original_filename), 'wb') do |file|
        file.write(avatar_param.read)
      end

      new_avatar = Avatar.create(user_id: current_user.id, file_name: avatar_param.original_filename)

      if current_avatar and new_avatar
        FileUtils.rm File.join(upload_path, current_avatar.file_name) rescue nil
        current_avatar.destroy
      end

      new_avatar
    end

  end
end
