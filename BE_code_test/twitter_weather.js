var TW = TW || {};

TW.Config = {
	// 	http://twitter.com/users/<Twitter Profile.json
	TWITTER_API_URL : "http://twitter.com/users",
	//  http://api.wunderground.com/api/c8d687c53a5511dd/conditions/q/<STATE ABBR>/<CITY>.json
	WEATHER_API_URL : "http://api.wunderground.com/api/c8d687c53a5511dd/conditions/q"
}


TW.Twitter = {
	GetProfile : function(profile_name)
	{
		var url_parameters = "output=jsonp&callback=TW.Twitter.HandleResponse";

		var scriptTag = document.createElement('SCRIPT');
		scriptTag.src = TW.Config.TWITTER_API_URL + "/" + profile_name + ".json?" + url_parameters;
		scriptTag.id = "twitter_response";
		document.getElementsByTagName('HEAD')[0].appendChild(scriptTag);
	},
	HandleResponse : function(json_response)
	{
		//cleanup script tag
		element = document.getElementById("twitter_response");
		element.parentNode.removeChild(element);

		var user_location = TW.Twitter.GetLocation(json_response);
		if(user_location != null)
		{
			TW.Weather.GetWeather(user_location);
		}
	},
	GetLocation : function(json_response)
	{
		if(json_response.location != null)
		{
			return json_response.location;
		}
		return null;
	}
}

TW.Weather = {
	GetWeather : function(user_location)
	{
		var location_array = user_location.split(',');
		var city = location_array[0].replace(/^\s+|\s+$/g, "").replace(/ /g,"_");
		var state = location_array[1].replace(/^\s+|\s+$/g, "");

		
		var scriptTag = document.createElement('SCRIPT');
		scriptTag.src = TW.Config.WEATHER_API_URL + "/" + state + "/" + city + ".json?output=jsonp&callback=TW.Weather.HandleResponse";
		scriptTag.id = "weather_underground_response";
		document.getElementsByTagName('HEAD')[0].appendChild(scriptTag);
	},
	HandleResponse : function(json_response)
	{
		//cleanup script tag
		element = document.getElementById("weather_underground_response");
		element.parentNode.removeChild(element);

		TW.Weather.AlertWeather(json_response);
	},
	AlertWeather : function(json_response)
	{
		var conditions = json_response.current_observation.weather;
		var temperature = json_response.current_observation.temp_f + "f";
		var last_observation = json_response.current_observation.observation_time;

		alert("Weather as of: "+ last_observation 
				+ " \n Conditions: " + conditions 
				+ " \n Temperature: " + temperature );
	}

}

//var api_response = TW.Twitter.GetProfile("TheScienceGuy");
