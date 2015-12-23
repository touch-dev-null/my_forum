require_dependency "my_forum/application_controller"

module MyForum
  class AttachmentsController < ApplicationController

    def create
      upload_path = File.join(Attachment::UPLOAD_PATH, current_user.id.to_s)

      # Create dir of not exists
      FileUtils::mkdir_p upload_path

      attachment_ids = []

      params[:files].each do |uploaded_io|
        next unless Attachment::ALLOWED_FILE_CONTENT_TYPE.include? uploaded_io.content_type

        file_name = "#{Time.now.to_i}_#{uploaded_io.original_filename}"
        File.open(File.join(upload_path, file_name), 'wb') do |file|
          file.write(uploaded_io.read)
        end

        attachment = Attachment.create(user_id: current_user.id, file_name: file_name)
        attachment_ids.push attachment.id
      end

      render json: { success: true, attachments: attachment_ids }.to_json
    end

  end
end
