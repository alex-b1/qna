class AnswersController < ApplicationController
  before_action :authenticate_user!

  def show; end

  def new; end

  def create
    @answer = question.answers.create(answer_params.merge(user: current_user))
  end

  def update
    if current_user&.author?(answer)
      answer.update(answer_params)
      answer
    end
  end

  def destroy
    if current_user.author?(answer)
      answer.destroy
      flash[:notice] = 'Destroyed successfully'
    end
  end

  def mark_as_best
    @question = answer.question
    answer.mark_as_best if current_user.author?(@question)
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Question.new
  end

  helper_method :question, :answer

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url, :_destroy])
  end
end
