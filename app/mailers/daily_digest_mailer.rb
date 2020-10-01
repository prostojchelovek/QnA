class DailyDigestMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_digest_mailer.digest.subject
  #
  def digest(user, questions_ids)
    @questions = Question.where(id: questions_ids)

    mail to: user.email
  end
end
