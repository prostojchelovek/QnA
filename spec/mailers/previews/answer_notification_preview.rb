# Preview all emails at http://localhost:3000/rails/mailers/answer_notification
class AnswerNotificationPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/answer_notification/notify
  def notify
    AnswerNotificationMailer.notify
  end

end
