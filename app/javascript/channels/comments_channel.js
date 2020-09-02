import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
  const questionId = $('.question').attr('question-id')

  consumer.subscriptions.create({ channel: "CommentsChannel" }, {
    connected() {
      this.perform("follow", {
        id: questionId
      });
    },

    received(data) {
      var comment = `<br> <p>${(data.body)}</p>`

      if (gon.user_id != data.user_id) {
        if (data.commentable_type == 'Question') $(`.question_comments`).append(comment)
        if (data.commentable_type == 'Answer') $(`#answer-comments-${data.commentable_id}`).append(comment)
      }
    }
  })
})
