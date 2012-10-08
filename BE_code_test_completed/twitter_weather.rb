#!/usr/bin/env ruby

require 'net/http'
require 'uri'
require 'json'

module TW
	class Config
		# 	http://twitter.com/users/<Twitter Profile>.json
		TWITTER_API_URL = "http://twitter.com/users"
		#  http://api.wunderground.com/api/c8d687c53a5511dd/conditions/q/<STATE ABBR>/<CITY>.json
		WEATHER_API_URL = "http://api.wunderground.com/api/c8d687c53a5511dd/conditions/q"
	end

	class Util
		def self.get_url(url)
			response = Net::HTTP.get(URI.parse(url))
			return response
		end

		def self.process_json_response(json_response)
	    	json_profile = JSON.parse(json_response)
	    	return json_profile
	    end
	end

	class Twitter
		def get_profile(profile_name)
			url = TW::Config::TWITTER_API_URL + "/#{profile_name}.json"
			TW::Util.process_json_response( TW::Util.get_url(url) )
		end

		def get_location(profile_json)
			profile_json["location"]
		end
	end

	class Weather
		def get_weather(user_location)
			location_array = user_location.split(',')
			city = location_array[0].strip.sub!('_', ' ')
			state = location_array[1].strip

			weather_url = "#{TW::Config::WEATHER_API_URL}/state/city.json"
			json_response = TW::Util::get_url(weather_url)
			return TW::Util::process_json_response(json_response)
		end

		def print_weather(json_response)
			conditions = json_response["current_observation"]["weather"]
			temperature = "#{json_response['current_observation']['temp_f']} f"
			last_observation = json_response["current_observation"]["observation_time"]

			puts "\n\n Weather as of: #{last_observation} \n Conditions: #{conditions} \n Temperature: #{temperature} \n\n"
		end
	end
end

profile_name = ARGV[1] || "TheScienceGuy"

twitter = TW::Twitter.new
profile_json = twitter.get_profile(profile_name)
location = twitter.get_location(profile_json)

weather = TW::Weather.new
weather_json = weather.get_weather(location)
weather.print_weather(weather_json)

