class NotificationsJob < ApplicationJob
  queue_as :default

  def perform(obj)
    NotificationService.new(obj).send_notification()
  end
end
