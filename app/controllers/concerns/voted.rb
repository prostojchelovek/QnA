module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %w[vote_up vote_down cancel_vote]
  end

  def vote_up
    authorize! :vote_up, @votable
    unless current_user.author_of?(@votable)
      @votable.vote_up(current_user)
      render_json
    end
  end

  def vote_down
    authorize! :vote_down, @votable
    unless current_user.author_of?(@votable)
      @votable.vote_down(current_user)
      render_json
    end
  end

  def cancel_vote
    authorize! :cancel_vote, @votable
    @votable.votes.find_by(user_id: current_user)&.destroy
    render_json
  end

  private

  def render_json
    render json: { value: @votable.rating, klass: @votable.class.to_s, id: @votable.id }
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end
end
