class Question < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :user
  has_one :reward, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true

  after_create :create_subscription

  def best_answer
    answers.best_answer.first
  end

  private

  def create_subscription
    subscriptions.create(user: user)
  end
end