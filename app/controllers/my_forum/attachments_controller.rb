require_dependency "my_forum/application_controller"

module MyForum
  class AttachmentsController < ApplicationController

    def create
      upload_path = File.join(Attachment::UPLOAD_PATH, current_user.id.to_s)

      # Create dir of not exists
      FileUtils::mkdir_p upload_path

      uploaded_io = params[:file]
      File.open(File.join(upload_path, uploaded_io.original_filename), 'wb') do |file|
        file.write(uploaded_io.read)
      end

      attachment = Attachment.create(user_id: current_user.id, file_name: uploaded_io.original_filename)

      render json: { success: true, attachment_id: attachment.id }
    end

  end
end
