module MyForum
  class ApplicationController < ActionController::Base

    before_filter :user_activity

    helper_method :attachment_img_path, :emoticons_list

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

    def new_pm_count
      return unless current_user
      PrivateMessage.unread_count_for(current_user)
    end
    helper_method :new_pm_count

    def forum_time(time)
      local_time = time

      if local_time.to_date == Time.now.to_date
        return t('my_forum.today', hhmm: local_time.strftime('%H:%M'))
      elsif local_time.to_date == (Time.now - 1.day).to_date
        return t('my_forum.yesterday', hhmm: local_time.strftime('%H:%M'))
      end

      local_time.strftime('%Y-%m-%d %H:%M')
    end
    helper_method :forum_time

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

    def attachment_img_path(attachment_id)
      attachment = Attachment.find_by_id(attachment_id.to_i)
      File.join(Attachment::URL, attachment.user_id.to_s, attachment.file_name)
    end

    def emoticons_list
      Emoticon.all.inject({}) {|hash, smile| hash.merge!(smile.code => File.join(Emoticon::URL, smile.file_name) ) }
    end
  end
end
