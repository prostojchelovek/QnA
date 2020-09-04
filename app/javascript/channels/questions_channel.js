import consumer from "./consumer";

consumer.subscriptions.create("QuestionsChannel", {
  connected() {
    // console.log("Connected");
  },

  received(data) {
    $(".questions").append(data);
  }
});
