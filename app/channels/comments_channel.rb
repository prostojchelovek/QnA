class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "question_comments_#{data['id']}"
  end
end
