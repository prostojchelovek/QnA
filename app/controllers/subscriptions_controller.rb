class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create, :destroy]

  def create
    authorize! :subscribe, @question
    @question.subscribe(current_user)
    flash['notice'] = 'Subscribed'
  end

  def destroy
    authorize! :unsubscribe, @question
    @question.unsubscribe(current_user)
    flash['notice'] = 'Unsubscribed'
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end
end
