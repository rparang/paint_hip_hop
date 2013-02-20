function playFeedTrack(youtube_id, feed_item_id) {
  //var video = "<iframe title='YouTube video player' width='568' height='310' src='http://www.youtube.com/embed/"+youtube_id+"?wmode=opaque&autoplay=1' frameborder='0' allowfullscreen></iframe>";
  $("#cover-"+feed_item_id).click(function() {
    /*$("#media-container-"+feed_item_id).fadeOut(150, function() {
      $("#cover-"+feed_item_id).removeClass('floatleft').html(video);
      $("#media-container-"+feed_item_id).fadeIn(150);
      $("#info-"+feed_item_id).css('width','543px');*/
      //});
    initialize(field.getValue(), tracks[field.getValue()]);
    var track_index = jQuery.inArray(youtube_id, tracks);
    loadNewVideo(youtube_id, track_index);
  });
};


jQuery.extend({
  getValues: function(url) {
    var result = null;
    $.ajax({
        url: url,
        type: 'get',
        dataType: 'json',
        async: false,
        success: function(data) {
            result = data;
        }
    }).done( function(data) {
      $.each(data, function (i, item) {
        $('<li>').attr({
          id: 't-'+i,
          class: 'track',
          'data-track': item.youtube_id
        })
        .appendTo("#track-listing");
        $('<span>').html(item.title).appendTo("#t-"+i);
        $("#t-"+i).click(function() {
          $t = $(this).data('track');
          $r = i;
          field.setValue(i);
          loadNewVideo($t, $r);
        })
      });
    });
    return result;
  }
});

function Field(val){
  var value = val;
  this.getValue = function(){
      return value;
  };
  this.setValue = function(val){
      value = val;
  };
}

function loadPlayer(track_id) {
  var params = { allowScriptAccess: "always" };
  var atts = { id: "ytapiplayer" };
  swfobject.embedSWF("http://www.youtube.com/v/" + track_id + 
                     "?version=3&enablejsapi=1&playerapiid=player1&autoplay=0", 
                     "yt-player", "250", "220", "9", null, null, params, atts);
}

function initialize(start_index, track_id) {
  loadPlayer(track_id);
  updatePlayerStyle(start_index);
}

function updatePlayerStyle(track_index) {
  $s = $("#t-"+track_index);
  $('.track').removeClass('selected');
  $s.addClass('selected');
}

function play() {
  ytapiplayer.playVideo();
}

function pause() {
  ytapiplayer.pauseVideo();
}

function stop() {
  ytapiplayer.stopVideo();
}

function loadNewVideo(track_id, track_index) {
  updatePlayerStyle(track_index);
  ytapiplayer.loadVideoById(track_id);
}

function halfMute(value) {
  ytapiplayer.setVolume(value);
}

function nextVideo() {
  ytapiplayer.nextVideo();
}

function updatePlayerInfo() {
  if(ytplayer && ytplayer.getDuration) {
    $('#videoDuration').html(ytplayer.getDuration());
    $('#videoCurrentTime').html(ytplayer.getCurrentTime());
    $('#bytesTotal').html(ytplayer.getVideoBytesTotal());
    $("#startBytes").html(ytplayer.getVideoStartBytes());
    $("#bytesLoaded").html(ytplayer.getVideoBytesLoaded());
  }
}
  
function onYouTubePlayerReady(playerId) {
  ytplayer = document.getElementById("ytapiplayer");
  ytplayer.addEventListener("onStateChange", "onytplayerStateChange");
  setInterval(updatePlayerInfo, 500);
  updatePlayerInfo();
}
