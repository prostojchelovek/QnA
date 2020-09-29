class AnswerNotification
  def send_notification(answer)
    answer.question.subscribers.find_each do |user|
      AnswerNotificationMailer.notify(user, @answer, @question).deliver_later
    end
  end
end
