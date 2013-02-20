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
      beforeSend: fadeComment(feed_id)
    }).done(function(data){
        buildCommentOnFeed(data);
        restoreComment(data);
       });
    return false;
  });
};

function fadeComment(feed_id) {
  $("#comment-form-container-"+feed_id).css('opacity', 0.5);
}

function restoreComment(data) {
  var obj = jQuery.parseJSON(data);
  $("#comment-form-container-"+obj.video_id).css('opacity', 1.0);
}

function buildCommentOnFeed(data) {
  var obj = jQuery.parseJSON(data);
  var image;
  obj.image == null ? image = "/assets/default-small.png" : image = obj.image;
  $("#comment-"+obj.video_id).text(obj.comment_count+" comments");
  $("#input-"+obj.video_id).val('');
  $("#comment-form-container-"+obj.video_id).before("<div class='comment-item' id='comment-"+obj.comment.id+"'><div class='comment-image'><a href='"+obj.path+"'><img src="+image+" title='"+obj.name+"' /></a></div><div class='comment-username'><a href='"+obj.path+"'>"+obj.name+"</a><p>"+obj.comment.content+"</p></div><div class='comment-time'></div></div>");
};

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