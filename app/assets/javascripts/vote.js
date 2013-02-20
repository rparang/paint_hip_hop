//Add vote on media and feed
//--------------------------------------------------------

function addVoteOnMedia(video_id, current_user_id, isFeed) {
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
      addVotesAndFacesOnFeed(data);
    }
    else {
      addVotesAndFacesOnMedia(data);
    }
  });
  return false;
};

function addVotesAndFacesOnMedia(data) {
  var image;
  var obj = jQuery.parseJSON(data);
  obj.image == null ? image = "/assets/default-small.png" : image = obj.image;
  $("#points-value").text(obj.vote_count+ " points");
  $("#points-container").append("<a href="+obj.path+"><img src="+image+" title="+obj.name+" style='width:39px;''></a>");
};

function addVotesAndFacesOnFeed(data) {
  var image;
  var obj = jQuery.parseJSON(data);
  var vote_count = parseInt(obj.vote_count);
  var points = vote_count - 1;
  obj.image == null ? image = "/assets/default-small.png" : image = obj.image;
  $("#points-value-"+obj.video_id).text("You and "+points+ " people liked this");
  $("#faces-"+obj.video_id).append("<a href="+obj.path+"><img src="+image+" title="+obj.name+" class='image-round-3' style='width:28px;''></a>");
  $("#sunglasses-"+obj.video_id).addClass('voted');
};
