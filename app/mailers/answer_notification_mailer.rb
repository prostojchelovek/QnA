class AnswerNotificationMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.answer_notification_mailer.notify.subject
  #
  def notify(user, answer, question)
    @answer = answer
    @question = question
    mail to: user.email, subject: 'Notification'
  end
end
