//Ajax functionality for music sort including recent, day, 
//week, month and all time
//--------------------------------------------------------

function filterFeed(el, pagelessHTML, pagelessPagesCount) {
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
      $('#results').html(data); //Replace HTML within #results with data, populated with the shared/feed partial
      $('#loading-feed').toggle();
      if (value == "#feed") {
        $('#results').append(pagelessHTML); //Append Pageless loader div that is removed once #results is replaced
      }
    })
    .bind('ajax:complete', function(evt, xhr, status){
      //var $label = $(value);
      //$(value).text($label.data('origText')); //Restore label
    })
  });
};