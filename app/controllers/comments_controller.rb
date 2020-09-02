class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_resource, only: :create

  after_action :publish_comment, only: :create

  def create
    @comment = @resource.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def find_resource
    if params[:question_id]
      @resource = Question.find(params[:question_id])
    else
      @resource = Answer.find(params[:answer_id])
    end
  end

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast(
      "question_comments_#{ @resource.is_a?(Question) ? @resource.id : @resource.question.id }",
      @comment
    )
  end
end
