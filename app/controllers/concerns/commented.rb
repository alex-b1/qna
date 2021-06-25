module Commented
  extend ActiveSupport::Concern

  included do
    after_action :publish_comment, only: :make_comment
  end

  def make_comment
    @comment = record.comments.create(comment_params.merge(user: current_user))
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def record
    model_klass.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body, files: [])
  end

  def publish_comment
    if @comment.errors.any?
      return
    end

    id = @comment.commentable_type == "Answer" ? @comment.commentable.question.id : @comment.commentable.id

    ActionCable.server.broadcast("comments_#{id}", {
        partial: ApplicationController.render(partial: 'comments/comment',
                                              locals: { comment: @comment, current_user: nil }),
        comment: @comment})
  end
end