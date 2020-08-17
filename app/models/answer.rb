class Answer < ApplicationRecord
  default_scope -> { order(best: :desc) }

  belongs_to :user
  belongs_to :question

  validates :body, presence: true

  def choose_the_best
    Answer.transaction do
      question.answers.where(best: true).first&.update!(best: false) 
      update!(best: true)
    end
  end
end
