class Answer < ApplicationRecord
  default_scope -> { order(best: :desc) }

  belongs_to :user
  belongs_to :question

  validates :body, presence: true

  def choose_the_best
    transaction do
      question.answers.where(best: true).update_all(best: false)
      update!(best: true)
    end
  end
end
