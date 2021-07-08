class NotificationsMailer < ApplicationMailer
  def notifications(user, answer)
    @answer = answer
    @question = answer.question

    mail to: user.email
  end
end
