var Remote = {

	container: function(el) {
		el.bind("ajax:success", function(evt, data, status, xhr){
			console.log(data);
			$('.container').html(data);
			var stateObj = { foo: "bar" };
			history.pushState( stateObj, "new page title", "gooz" )
		});
	}

}

$('document').ready(function() {
	var $home = $('home');
	Remote.container($home);
});