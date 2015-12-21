module MyForum
  class Avatar < Image
    belongs_to :user

    UPLOAD_PATH = File.join(Rails.public_path, 'uploads', 'avatars')
    URL  = File.join('/uploads', 'avatars')

    ALLOWED_FILE_EXTENSIONS = %w(.jpg .jpeg .png .gif)
  end
end
