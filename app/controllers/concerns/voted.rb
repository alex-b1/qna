module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[vote_up vote_down cancel_vote]
  end

  def vote_up
    if current_user.author?(@votable)
      return render_errors
    end

    @votable.vote_up(current_user)
    render_json
  end

  def vote_down
    if current_user.author?(@votable)
      return render_errors
    end

    @votable.vote_down(current_user)
    render_json
  end

  def cancel_vote
    if current_user.author?(@votable)
      return render_errors
    end

    @votable.cancel_vote_of(current_user)
    render_json
  end

  private

  def render_json
    render json: { resource_name: @votable.class.name.downcase,
                   resource_id: @votable.id,
                   rating: @votable.rating }
  end

  def render_errors
    render json: { message: "You're an author, or not authorized" },
           status: :forbidden
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end