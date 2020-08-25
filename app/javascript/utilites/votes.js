$(document).on("turbolinks:load", function() {
  $(".vote .voting").on("ajax:success", function(e) {
    var data = e.detail[0];
    $(".vote-" + data.klass.toLowerCase() + "-" + data.id + " .rating").html(
      "rating: " + data.value
    );
  });
});
