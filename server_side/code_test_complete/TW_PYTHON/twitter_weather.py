#!/usr/bin/python

import urllib2
import json
import sys

class TW:
	class Config:
		@staticmethod
		def TWITTER_API_URL():
		    return "http://twitter.com/users"

		@staticmethod
		def WEATHER_API_URL():
			return "http://api.wunderground.com/api/c8d687c53a5511dd/conditions/q"		

	class Util:
		@staticmethod
		def GetUrl(url):
			req = urllib2.Request(url, None, {'Content-Type': 'application/json'})
			f = urllib2.urlopen(req)
			json_response = f.read()
			f.close()
			return TW.Util.ProcessJsonResponse(json_response)

		@staticmethod
		def ProcessJsonResponse(json_response):
			json_profile = json.loads(json_response)
			return json_profile

	class Twitter:
		def GetProfile(self, profile_name):
			url = TW.Config.TWITTER_API_URL() + "/" + profile_name + ".json"
			return TW.Util.GetUrl(url)

		def GetLocation(self, profile_json):
			location = profile_json["location"]
			return location

	class Weather:
		def GetWeather(self, user_location):
			location_array = user_location.split(',')
			city = location_array[0].strip().replace(' ','%20')
			state = location_array[1].strip()

			weather_url = TW.Config.WEATHER_API_URL() + "/" + state + "/" + city + ".json"
			return TW.Util.GetUrl(weather_url)
			

		def PrintWeather(self, weather_json):
			conditions = weather_json["current_observation"]["weather"]
			temperature = weather_json["current_observation"]["temperature_string"]
			last_observation = weather_json["current_observation"]["observation_time"]

			print "\n\n Weather as of: " + last_observation + "\n Conditions: " + conditions + "\n Temperature: " + temperature + "\n\n"

profile_name = "TheScienceGuy"
if (len(sys.argv) > 1): 
	profile_name = sys.argv[1]

twitter = TW.Twitter()
profile_json = twitter.GetProfile( profile_name )
location = twitter.GetLocation(profile_json)

weather = TW.Weather()
weather_json = weather.GetWeather(location)
weather.PrintWeather(weather_json)

