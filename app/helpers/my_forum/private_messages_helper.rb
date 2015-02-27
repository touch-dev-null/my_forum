module MyForum
  module PrivateMessagesHelper

    def new_pm_button
      return unless current_user
      content_tag :div, class: 'new_pm_button' do
        link_to t('my_forum.create_new_pm'), new_private_message_path, class: 'btn btn-primary'
      end
    end

    def new_private_messages_count_bage
      return unless current_user
      return if (count = new_pm_count).eql?(0)
      content_tag(:span, count, class: 'badge')
    end

  end
end
