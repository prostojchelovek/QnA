class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: %w[create]
  before_action :find_answer, only: %w[update destroy choose_the_best]

  after_action :publish_answer, only: [:create]

  include Voted

  authorize_resource

  def create
    @answer = @question.answers.create(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    @answer.destroy
  end

  def choose_the_best
    @answer.choose_the_best
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end


  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url, :id, :_destroy])
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast("question_#{@answer.question_id}", @answer)
  end
end
