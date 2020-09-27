class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :load_question, only: %i[show update destroy]

  authorize_resource

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    render json: @question
  end

  def create
    @question = current_resource_owner.questions.new(question_params)
    @question.save
    render json: @question
  end

  def update
    @question.update!(question_params)
    render json: @question
  end

  def destroy
    @question.destroy
    render json: @question
  end

  private

  def question_params
    params.require(:question).permit(:body, :title, links_attributes: [:id, :name, :url, :_destroy], reward_attributes: [:name, :file])
  end

  def load_question
    @question = Question.find(params[:id])
  end
end
