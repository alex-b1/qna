class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_attachment

  def destroy
    @attachment.purge if current_user&.author?(@attachment&.record)
  end

  private

  def find_attachment
    @attachment = ActiveStorage::Attachment.find_by(id: params[:id])
  end
end
