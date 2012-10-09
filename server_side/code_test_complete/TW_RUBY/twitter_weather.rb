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
			#changed the script to pull http, not over ssl, because there is a bug in Net::HTTP
			#http://expressica.com/2012/02/10/eoferror-end-of-file-reached-issue-when-post-a-form-with-nethttp/
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
			location_array = user_location.split(",")
			city = location_array[0].strip()
			state = location_array[1].strip()

			weather_url = "#{TW::Config::WEATHER_API_URL}/#{state}/#{city}.json"
			json_response = TW::Util::get_url(weather_url)
			return TW::Util::process_json_response(json_response)
		end

		def print_weather(weather_json)
			conditions = weather_json["current_observation"]["weather"]
			temperature = weather_json["current_observation"]["temperature_string"]
			last_observation = weather_json["current_observation"]["observation_time"]

			puts "\n\n Weather as of: #{last_observation} \n Conditions: #{conditions} \n Temperature: #{temperature} \n\n"
		end
	end
end

profile_name = if !ARGV[0].nil? then ARGV[0] else "TheScienceGuy" end

twitter = TW::Twitter.new
profile_json = twitter.get_profile(profile_name)
location = twitter.get_location(profile_json)

weather = TW::Weather.new
weather_json = weather.get_weather(location)
weather.print_weather(weather_json)

