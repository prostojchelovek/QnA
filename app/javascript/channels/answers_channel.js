import consumer from "./consumer";

$(document).on("turbolinks:load", function() {
  const questionId = $('.question').attr('question-id');

  if (typeof questionId !== "undefined") {
    consumer.subscriptions.create("AnswersChannel", {
      connected() {
        this.perform("follow", {
          id: questionId
        });
      },
      received(data) {
        var answers = $(".answers");
        if (gon.user_id != data.user_id) {
          var answer = `<br> <p>${data["body"]}</p>`;
          answers.append(answer);
        }
      }
    });
  }
});
