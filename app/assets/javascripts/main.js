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

function secondsToHms(d) {
d = Number(d);
var h = Math.floor(d / 3600);
var m = Math.floor(d % 3600 / 60);
var s = Math.floor(d % 3600 % 60);
return ((h > 0 ? h + ":" : "") + (m > 0 ? (h > 0 && m < 10 ? "0" : "") + m + ":" : "0:") + (s < 10 ? "0" : "") + s); }