$(document).on("turbolinks:load", function() {
  $(".vote .voting").on("ajax:success", function(e) {
    var data = e.detail[0];
    var voteClass = ".vote-" + data.klass.toLowerCase() + "-" + data.id;
      $(voteClass + " .rating").html("rating: " + data.value);
      $(voteClass + " .cancel-vote-link").removeClass("hidden");
      $(voteClass + " .voting").addClass("hidden");
    });

  $(".re-vote").on("ajax:success", function(e) {
    var data = e.detail[0];
    var voteClass = ".vote-" + data.klass.toLowerCase() + "-" + data.id;
    $(voteClass + " .rating").html("rating: " + data.value);
    $(voteClass + " .cancel-vote-link").addClass("hidden");
    $(voteClass + " .voting").removeClass("hidden");
  });
});
