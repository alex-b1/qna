class AnswersController < ApplicationController

  def show; end

  def new; end

  def create
    @answer = question.answers.new(answer_params)

    if @answer.save
      redirect_to answer_path(answer)
    else
      render :new
    end
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
    params.require(:answer).permit(:body)
  end
end
