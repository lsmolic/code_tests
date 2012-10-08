#!/usr/bin/env bash

. ticktick.sh

# 	http://twitter.com/users/<Twitter Profile>.json
TWITTER_API_URL="http://twitter.com/users"
#  http://api.wunderground.com/api/c8d687c53a5511dd/conditions/q/<STATE ABBR>/<CITY>.json
WEATHER_API_URL="http://api.wunderground.com/api/c8d687c53a5511dd/conditions/q"


function get_profile() 
{
    profile_data=`curl -s "${TWITTER_API_URL}/${PROFILE_NAME}.json"`
    tickParse "$profile_data"
    loc=``location``
    twitter_location=(${loc//,/ })
   
   #remove trailing and leading spaces
    city=$(echo "${twitter_location[0]} ${twitter_location[1]}" | sed 's/ *$//g' | sed 's/^ *//g' | sed 's/ /\%20/g') 
    state=$(echo ${twitter_location[2]} | sed 's/ *$//g' | sed 's/^ *//g') 
}


function get_weather()
{
	weather_data=`curl -s "${WEATHER_API_URL}/${state}/${city}.json"`
	tickParse "$weather_data"
	conditions=``current_observation.weather``
	temperature=``current_observation.temp_f``
	last_observation=``current_observation.observation_time``
}

function print_weather()
{
	echo -e "\n\n Weather as of: ${last_observation} \n Conditions: ${conditions} \n Temperature: ${temperature} \n\n"
}


PROFILE_NAME="TheScienceGuy"
if [ "$#" -eq 1 ]; then  #|| die "1 argument required, $# provided"  #(only if you want to restrict)
	PROFILE_NAME=$1
fi


get_profile
get_weather
print_weather





