//Ajax functionality for music sort including recent, day, 
//week, month and all time
//--------------------------------------------------------

function loadSongs(el, pagelessHTML, pagelessPagesCount) {
  //console.log(pagelessPagesCount);
  $.each(el, function(key,value){
    $(value)
    .bind("ajax:beforeSend", function(evt, xhr, settings){
      //var $label = $(value);
      //$label.data('origText', $(this).text() ); //Store label
      //$label.text("Loading...");
      $('#results').css('opacity','0.5');
      $('#loading-feed').toggle();
    })
    .bind("ajax:success", function(evt, data, status, xhr){
      $('#results').css('opacity','1');
      $('#results').html(data); //Replace HTML within #results with data, which is populated with the shared/feed partial
      $('#loading-feed').toggle();
      if (value == "#feed") {
        $('#results').append(pagelessHTML); //Append Pageless loader div that
      //is removed once the #results is replaced using the html() method
      }
    })
    .bind('ajax:complete', function(evt, xhr, status){
      //var $label = $(value);
      //$(value).text($label.data('origText')); //Restore label
    })
  });
};


//Trending songs on front page
//--------------------------------------------------------

function xhr_get(url) {
  $.ajax ({
    url: url,
    dataType: "json",
    type: "GET",
    processData: false,
    contentType: "application/json",
    beforeSend: showLoading()
  }).done( function(data) {
    buildTrending(data);
    hideLoading();
  });
};

function buildTrending(data) {
  var limit = 4;
  //console.log(data);
  $.each(data, function(i,item) {
    //console.log(item);
    if(i > limit) return false;
    var img_url = 'http://i2.ytimg.com/vi/'+item.youtube_id+'/mqdefault.jpg';
    var base_url = '/videos/'+item.id;
    $("<div>").attr({
      class: 'more-from-user-item',
      id: 'item-'+i
      }).appendTo("#items-trending");
    $("<div>").attr({
      class: 'more-from-user-image',
      id: 'item-image-'+i
      }).appendTo("#item-"+i);
    $("<a>").attr({
      href: base_url
      })
      .append("<img src="+img_url+" />")
      .appendTo("#item-image-"+i);
    $("<div>").attr({
      class: 'more-from-video-info',
      id: 'item-info-'+i
      }).appendTo("#item-"+i);
    $("<a>").attr({
      href: base_url,
      class: 'title'
      })
      .html(item.title)
      .appendTo("#item-info-"+i);
    $("<div>")
      .html("<div class='vote'></div>"+item.votes_count)
      .appendTo("#item-info-"+i);
  });
}

function showLoading() {
  $("#loading").html("Loading...");
}

function hideLoading() {
  $("#loading").empty();
}


//Search music via YouTube's API 
//--------------------------------------------------------

function getSongs(who) {
  $.getJSON('http://gdata.youtube.com/feeds/api/videos?start-index=1&max-results=15&v=2&alt=json-in-script&callback=?', 
    {
      q: who,
      orderby: 'relevance'
    },
    function(data) {
      $("<div class='search-header'>Select a song to preview and post...</div>").appendTo("#search-results");
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
  var $h6 = $('<h6>')
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
  $h6.html(video.title.$t).appendTo('#r-'+video.id.$t.split(":")[3]);
  $("<p>").html(video_duration).appendTo('#r-'+video.id.$t.split(":")[3]);

}


//Add vote on media and feed
//--------------------------------------------------------

function addPointOnMedia(video_id, current_user_id, isFeed) {
  $("#vote").off().removeClass('button-hover').addClass('voted');
  $("#vote-"+video_id).off();
  $("#vote-"+video_id+" span").text('Liked');
  $("#media-container-"+video_id).addClass('voted');
  $("#actions-"+video_id).addClass('voted');
  $.ajax({
    type: "POST",
    url: "/votes",
    data: {vote: {
      video_id: video_id,
      user_id: current_user_id
    }}
  }).done(function (data) {
    if(isFeed) {
      addPointsAndFacesOnFeed(data);
    }
    else {
      addPointsAndFacesOnMedia(data);
    }
  });
  return false;
};

function addPointsAndFacesOnMedia(data) {
  var image;
  var obj = jQuery.parseJSON(data);
  obj.image == null ? image = "/assets/default-small.png" : image = obj.image;
  $("#points-value").text(obj.vote_count+ " points");
  $("#points-container").append("<a href="+obj.path+"><img src="+image+" title="+obj.name+" style='width:39px;''></a>");
};

function addPointsAndFacesOnFeed(data) {
  var image;
  var obj = jQuery.parseJSON(data);
  var vote_count = parseInt(obj.vote_count);
  var points = vote_count - 1;
  obj.image == null ? image = "/assets/default-small.png" : image = obj.image;
  $("#points-value-"+obj.video_id).text("You and "+points+ " people liked this");
  $("#faces-"+obj.video_id).append("<a href="+obj.path+"><img src="+image+" title="+obj.name+" class='image-round-3' style='width:28px;''></a>");
  $("#sunglasses-"+obj.video_id).addClass('voted');
};



//Add and build comment
//--------------------------------------------------------

function addCommentOnMedia() {
  $('form').submit(function() {  
    var valuesToSubmit = $(this).serialize();
    $.ajax({
      type: "POST",
      url: $(this).attr('action'), //sumbits it to the given url of the form
      data: valuesToSubmit,
    }).done(function(data){
        buildCommentOnMedia(data);
       });
    return false; // prevents normal behaviour
  });
};

function buildCommentOnMedia(data) {
  var obj = jQuery.parseJSON(data)
  var image;
  obj.image == null ? image = "/assets/default-small.png" : image = obj.image;
  $("#comments-count").html(obj.comment_count+" comments");
  $("#comment_content").val('');
  $("#comment-form-container").before("<div class='comment-item' id='comment-"+obj.comment.id+"'><div class='comment-image'><a href='"+obj.path+"'><img src="+image+" title='"+obj.name+"' /></a></div><div class='comment-username'><a href='"+obj.path+"'>"+obj.name+"</a><p>"+obj.comment.content+"</p></div><div class='comment-time'></div></div>");
};

function addCommentOnFeed(feed_id) {
  $('#form-'+feed_id).submit(function() {  
    var valuesToSubmit = $(this).serialize();
    $.ajax({
      type: "POST",
      url: $(this).attr('action'),
      data: valuesToSubmit,
    }).done(function(data){
        buildCommentOnFeed(data);
       });
    return false;
  });
};

function buildCommentOnFeed(data) {
  var obj = jQuery.parseJSON(data)
  var image;
  obj.image == null ? image = "/assets/default-small.png" : image = obj.image;
  $("#comment-"+obj.video_id).text(obj.comment_count+" comments");
  $("#input-"+obj.video_id).val('');
  $("#comment-form-container-"+obj.video_id).before("<div class='comment-item' id='comment-"+obj.comment.id+"'><div class='comment-image'><a href='"+obj.path+"'><img src="+image+" title='"+obj.name+"' /></a></div><div class='comment-username'><a href='"+obj.path+"'>"+obj.name+"</a><p>"+obj.comment.content+"</p></div><div class='comment-time'></div></div>");
};


//Delete comment
//--------------------------------------------------------

function deleteComment() {
  $(".comment-delete").click(function() {
  $.ajax({ 
    url : this.href,
    type : 'DELETE', 
    dataType : 'html', 
    success : function(data) {
      var obj = jQuery.parseJSON(data);
      $("#comment-"+obj.comment.id).fadeOut();
     }
  });
  return false;
  });
};


//Expand player in feed
//--------------------------------------------------------

function expandPlayer(youtube_id, feed_item_id) {
  var video = "<iframe title='YouTube video player' width='568' height='310' src='http://www.youtube.com/embed/"+youtube_id+"?wmode=opaque&autoplay=1' frameborder='0' allowfullscreen></iframe>";
  $("#cover-"+feed_item_id).click(function() {
    $("#media-container-"+feed_item_id).fadeOut(150, function() {
      $("#cover-"+feed_item_id).removeClass('floatleft').html(video);
      $("#media-container-"+feed_item_id).fadeIn(150);
      $("#info-"+feed_item_id).css('width','543px');
    });
  });
};

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




