class DailyDigest
  def send_digest
    @questions_ids = Question.where(created_at: (Time.now - 24.hours)..Time.now).pluck(:id)
    User.find_each do |user|
      DailyDigestMailer.digest(user, @questions_ids).deliver_later
    end
  end
end
