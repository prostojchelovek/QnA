module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %w[vote_up vote_down]
  end

  def vote_up
    unless current_user.author_of?(@votable)
      @votable.vote_up(current_user)
      render_json
    end
  end

  def vote_down
    unless current_user.author_of?(@votable)
      @votable.vote_down(current_user)
      render_json
    end
  end

  private

  def render_json
    render json: { value: @votable.votes.pluck(:value).sum, klass: @votable.class.to_s, id: @votable.id }
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end
end
