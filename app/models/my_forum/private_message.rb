module MyForum
  class PrivateMessage < ActiveRecord::Base
    scope :unread_count_for, -> (user) { where(recipient_id: user.id, unread: true).count }
    scope :inbox_for, -> (user) { where(recipient_id: user.id) }

    attr_accessor :recipient
  end
end
