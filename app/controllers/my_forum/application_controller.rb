module MyForum
  class ApplicationController < ActionController::Base

    before_filter :user_activity

    def authenticate_user!
      redirect_to admin_signin_path unless current_user
    end

    def current_user
      return session[:user_id].blank? ? nil : User.where(id: session[:user_id]).includes(:user_groups).first
    end
    helper_method :current_user

    def current_user_id
      session[:user_id]
    end
    helper_method :current_user_id

    def current_user_groups
      return [].push UserGroup::GUEST_GROUP.name unless current_user
      current_user.user_groups.map &:name
    end

    private

    def user_activity
      current_user.touch if current_user
    end

    def verify_admin
      redirect_to root_path unless current_user && current_user.is_admin
    end

    def check_access_permissions(obj)
      return true if current_user && current_user.is_admin

      category_user_groups = case obj.class.to_s
                               when 'MyForum::Forum'
                                 obj.category.user_groups
                               when 'MyForum::Topic'
                                 obj.forum.category.user_groups
                               else
                                 []
                             end

      redirect_to root_path if (category_user_groups.map(&:name) & current_user_groups).blank?
    end
  end
end
