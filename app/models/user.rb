class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :badges, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  def author_of?(resource)
    resource.user_id == id
  end

  def already_voted?(resource)
    votes.exists?(votable: resource)
  end

  def find_subscription(question)
    subscriptions.where(question_id: question.id).first
  end
end
