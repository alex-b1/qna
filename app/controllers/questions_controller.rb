class QuestionsController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!, except: [:index, :show]
  before_action :subscription, only: %i[show update]
  after_action :publish_question, only: :create

  authorize_resource

  def index
    @questions = Question.all
    gon.push({current_user: current_user})
    gon.push({question_id: question.id})
  end

  def show
    @answer = Answer.new
    @answer.links.new

    gon.push({current_user: current_user})
    gon.push({question_id: question.id})
  end

  def new
    @question = Question.new
    @question.links.new
    @question.build_reward
  end

  def edit; end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    question.update(question_params)
    question
  end

  def destroy
    question.destroy if authorize! :destroy, question
    redirect_to questions_path
  end

  private

  def publish_question
    if @question.errors.any?
      return
    end

    ActionCable.server.broadcast('questions', {
        partial: ApplicationController.render( partial: 'questions/question',
                                               locals: { question: question, current_user: current_user }),
        question: question})
  end

  def subscription
    @subscription = question.subscriptions.find_by(user: current_user)
  end

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body,
                                     files: [],
                                     links_attributes: [:id, :name, :url, :_destroy],
                                     reward_attributes: [:title, :image]
    )
  end
end