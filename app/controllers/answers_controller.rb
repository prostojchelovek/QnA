class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: %w[create]
  before_action :find_answer, only: %w[update destroy choose_the_best]

  def create
    @answer = @question.answers.create(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
      @question = @answer.question
    else
      head :forbidden
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
    else
      head :forbidden
    end
  end

  def choose_the_best
    if current_user.author_of?(@answer.question)
      @answer.choose_the_best
    else
      head :forbidden
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end


  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end
end
