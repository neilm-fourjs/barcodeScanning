onICHostReady = function(version) {

	if ( version != 1.0 ) {
		alert('Invalid API version');
		return;
	}

	gICAPI.onFocus = function( polarity ) {
		if ( polarity ) {
			obj = document.getElementById("controls");
			obj.setAttribute("style","fill:green");
		} else {
			obj = document.getElementById("controls");
			obj.setAttribute("style","fill:red");
		}
	}

	gICAPI.onData = function( data ) {
		document.getElementById("result_strip").innerHTML = data;
	}

	gICAPI.onProperty = function(property) {						   
	}
}
