require_dependency "my_forum/application_controller"

module MyForum
  class Admin::EmoticonsController < ApplicationController
    before_filter :verify_admin

    layout 'layouts/my_forum/admin_application'

    def index
      @emoticons = Emoticon.all
    end

    def new
      @emoticon = Emoticon.new
    end

    def create
      #TODO validation add

      # Create dir of not exists
      FileUtils::mkdir_p Emoticon::UPLOAD_PATH

      uploaded_io = params[:emoticon][:file_name]
      File.open(File.join(Emoticon::UPLOAD_PATH, uploaded_io.original_filename), 'wb') do |file|
        file.write(uploaded_io.read)
      end

      attachment = Emoticon.create(code: params[:emoticon][:code], file_name: uploaded_io.original_filename, is_active: true)

      redirect_to admin_emoticons_path
    end

    def edit
      @emoticon = Emoticon.find(params[:id])
    end

    def update
      emoticon = Emoticon.find(params[:id])
      emoticon.update(emoticon_params)

      redirect_to admin_emoticons_path
    end

    def destroy
      return unless emoticon = Emoticon.find(params[:id])

      begin
        FileUtils.rm File.join(Emoticon::UPLOAD_PATH, emoticon.file_name)
        emoticon.destroy
      rescue
        Rails.logger.error 'can`t find and delete emoticon file'
      ensure
        emoticon.destroy
      end

      redirect_to admin_emoticons_path
    end

    private

    def emoticon_params
      params.require(:emoticon).permit(:code)
    end
  end
end
