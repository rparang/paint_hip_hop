//Ajax functionality for music sort including recent, day, 
//week, month and all time
//--------------------------------------------------------

function loadSongs(elementID, pagelessHTML) {
  $(elementID)
    .bind("ajax:beforeSend", function(evt, xhr, settings){
      var $label = $(this);
      $label.data('origText', $(this).text() ); //Store label
      $label.text("Loading...");
    })
    .bind("ajax:success", function(evt, data, status, xhr){
      var $pageless_html = pagelessHTML;
      $('#results').html(data); //Replace HTML within #results with data, which is populated with the shared/feed partial
      $('#results').append($pageless_html); //Append Pageless loader div that
      //is removed once the #results is replaced using the html() method
    })
    .bind('ajax:complete', function(evt, xhr, status){
      var $label = $(this);
      $(this).text($label.data('origText')); //Restore label
    })
};


//Search music via YouTube's API 
//--------------------------------------------------------

function getSongs(who) {
  $.getJSON('http://gdata.youtube.com/feeds/api/videos?start-index=1&max-results=15&v=2&alt=json-in-script&callback=?', 
    {
      q: who,
      orderby: 'relevance'
    },
    function(data) {
      if (data != null) {
        $.each(data.feed.entry, function(i, video) {
          searchView(video); //Build video search markup
        });
      }
      $("#loading-search").fadeOut(100); //Hide "Loading..."
    }
  );
}


//Build video search markup. This function is
//iterated for each video from the search query
//--------------------------------------------------------

function searchView(video) {
  var url = 'http://img.youtube.com/vi/';
  var video_id = video.id.$t.split(":")[3];
  var video_title = video.title.$t;
  var video_link = video.link[0].href.split("&")[0];
  var video_duration = video.media$group.media$content[0].duration;
  var $h1 = $('<h1>')
            .attr({
              title: video_title,
              alt: video_title
            });

  $("<div>")
    .attr({
      id: 'd-' + video_id,
      class: 'search-item',
      onclick: "window.location = '/videos/new?v=" + video_id + "';"
    })
    .appendTo("#search-results");
  $("<div>")
    .attr({
      id: 'l-' + video_id,
      class: 'search-left'
    }).appendTo('#d-'+video.id.$t.split(":")[3]);
  $('<img/>').attr('src', url + video.id.$t.split(":")[3] + '/default.jpg').appendTo('#l-'+video.id.$t.split(":")[3]);
  $("<div>")
    .attr({
      id: 'r-' + video_id,
      class: 'search-right'
    }).appendTo('#d-'+video.id.$t.split(":")[3]);
  $h1.html(video.title.$t).appendTo('#r-'+video.id.$t.split(":")[3]);
  $("<p>").html(video_duration).appendTo('#r-'+video.id.$t.split(":")[3]);

}

