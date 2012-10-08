<?
/*
	Attention! Oy! Achtung! 

	This PHP script should be written within a namespace to protect it from interfering with other scripts. Please follow a similar structure to the javascript example, but do not worry about attempting asynchronous web calls. 

	It is important to use current PHP5 standards and avoid globals whenever possible. The script will take an optional	commandline argument profile_name, which will replace the default 'TheScienceGuy'. Since Twitter has a problem requiring this field to be standardized, we chose one with "Los Angeles, CA, USA", thanks Bill Nye.

*/


namespace TW
{
	class Config
	{
		// 	http://twitter.com/users/<Twitter Profile>.json
		const TWITTER_API_URL = "http://twitter.com/users";
		//  http://api.wunderground.com/api/c8d687c53a5511dd/conditions/q/<STATE ABBR>/<CITY>.json
		const WEATHER_API_URL = "http://api.wunderground.com/api/c8d687c53a5511dd/conditions/q";
	}

	class Util
	{
		public static function getUrl($url)
		{
			// use curl to pull down the twitter json
			$ch = curl_init($url);
			curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
			curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);  //no ssl
			$output = curl_exec($ch);
			curl_close($ch); 
			return $output;
		}
		public static function processJsonResponse($json_response)
	    {
	    	$json_profile = json_decode($json_response, true);
	    	return $json_profile;
	    }
	}

	class Twitter
	{
	    public function getProfile($profile_name) 
	    {
	        $twitter_url = Config::TWITTER_API_URL."/$profile_name.json";

			$json_response = Util::getUrl($twitter_url);

			return Util::processJsonResponse($json_response);
	    }

	    public function getLocation($json_profile)
	    {
	    	return $json_profile["location"];
	    }
	}

	class Weather
	{
		public function getWeather($user_location)
		{
			$location_array = explode(",", $user_location);
			$city = str_replace(' ', '_', trim($location_array[0]));
			$state = trim($location_array[1]);

			$weather_url = Config::WEATHER_API_URL . "/$state/$city.json";
			$json_response = Util::getUrl($weather_url);
			return Util::processJsonResponse($json_response);
		}

		public function printWeather($json_response)
		{
			$conditions = $json_response['current_observation']['weather'];
			$temperature = $json_response['current_observation']['temp_f'] . "f";
			$last_observation = $json_response['current_observation']['observation_time'];

			printf("\n\n Weather as of: %s \n Conditions: %s \n Temperature: %s \n\n", $last_observation, $conditions, $temperature );
		}
	}

	$profile_name = "TheScienceGuy";
	if(!empty($argv) && count($argv) > 1 && $argv[1] != NULL)
	{
		$profile_name = $argv[1];
	}

	$twitter = new Twitter();
	$twitter_json = $twitter->getProfile($profile_name);
	$user_location = $twitter->getLocation($twitter_json);
	if(empty($user_location)){exit("\n\nUser doesn't list their location: $profile_name\n\n");}
	
	$weather = new Weather();
	$weather_json = $weather->getWeather($user_location);
	$weather->printWeather($weather_json);

}



?>