class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user
  has_many_attached :files
  has_many :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  after_create :email_notification

  scope :sort_by_best, -> { order(best: :desc) }
  scope :best_answer, -> { where(best: true) }

  def mark_as_best
    transaction do
      question.best_answer&.update!(best: false)
      update!(best: true)
      question.reward&.update!(user: user)
    end
  end

  private

  def email_notification
    NotificationsJob.perform_later(self)
  end
end
