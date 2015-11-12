module MyForum
  class Attachment < Image
    belongs_to :user, class_name: 'MyForum::User'
    belongs_to :post, class_name: 'MyForum::Post'

    UPLOAD_PATH = File.join(Rails.public_path, 'uploads', 'attachments')
  end
end
