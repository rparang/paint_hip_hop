function showLoading() {
  $("#loading").html("Loading...");
}

function hideLoading() {
  $("#loading").empty();
}

function truncateText(element,text_length) {
  var shortText = $(element).text();
  if (shortText.length > text_length) {
    var text = shortText.trim().substring(0,text_length)+"...";
  }
  else {
    var text = shortText;
  }
  $(element).html(text);
};



