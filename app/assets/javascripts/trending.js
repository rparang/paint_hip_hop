//Trending songs on front page
//--------------------------------------------------------

function getTrending(url) {
  var result = null;
  $.ajax ({
    url: url,
    dataType: "json",
    type: "GET",
    processData: false,
    contentType: "application/json",
    beforeSend: showLoading(),
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
