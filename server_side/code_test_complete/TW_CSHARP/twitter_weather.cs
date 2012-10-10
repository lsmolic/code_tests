using System;
using System.IO;
using System.Net;
using System.Collections.Generic;
using System.Collections;
using System.Text;

namespace TW 
{
	public static class Config
	{
	  public const string twitterApiUrl = "http://twitter.com/users";
	  public const string weatherApiUrl = "http://api.wunderground.com/api/c8d687c53a5511dd/conditions/q";
	}

	static class Util
	{
		public static string GetUrl(string url)
		{
			string jsonResponse = string.Empty;

	    var webRequest = System.Net.WebRequest.Create(url) as HttpWebRequest;
	    if (webRequest != null)
	    {
	        webRequest.Method = "GET";
	        webRequest.ServicePoint.Expect100Continue = false;
	        webRequest.Timeout = 20000;

	        webRequest.ContentType = "application/json";
	    }

	    HttpWebResponse resp = (HttpWebResponse)webRequest.GetResponse();
	    Stream resStream = resp.GetResponseStream();
	    StreamReader reader = new StreamReader(resStream);
	    jsonResponse = reader.ReadToEnd();
		
	    return jsonResponse;
		}

		public static Dictionary<string, object> ProcessJsonResponse(string jsonResponse)
		{
			object o = fastJSON.JSON.Instance.Parse(jsonResponse);
			Dictionary<string, object> dict = (Dictionary<string, object>)o;
			return dict;
	  }
	}

	public class Twitter
	{
		public Dictionary<string, object> GetProfile(string profileName)
		{
			string url = TW.Config.twitterApiUrl + "/" + profileName + ".json";
			string jsonResponse = TW.Util.GetUrl(url);
			return TW.Util.ProcessJsonResponse(jsonResponse);
		}

		public string GetLocation(Dictionary<string, object> profileJson)
		{
			object locationObject = new Object();
			if(!profileJson.TryGetValue("location", out locationObject))
			{
				throw new Exception("Error parsing 'location' from Twitter Json");
			}
			string location = locationObject.ToString();
			return location;
		}
	}

	public class Weather
	{
		public Dictionary<string, object> GetWeather(string userLocation)
		{
			string[] locationArray = userLocation.Split(',');
			string city = locationArray[0].Trim().Replace(" ", "%20");
			string state = locationArray[1].Trim();
			

			string weatherUrl = TW.Config.weatherApiUrl+"/"+state+"/"+city+".json";
			string jsonResponse = TW.Util.GetUrl(weatherUrl);
			return TW.Util.ProcessJsonResponse(jsonResponse);
		}

		public void PrintWeather(Dictionary<string, object> weatherJson)
		{
			object currentObservationObject = new Object();
			if( !weatherJson.TryGetValue("current_observation", out currentObservationObject) )
			{
				throw new Exception("Error parsing 'current_observation' from Weather Json");
			}
			Dictionary<string, object> currentObservation = (Dictionary<string, object>)currentObservationObject;
			object conditionsObject = new Object();
			if ( !currentObservation.TryGetValue("weather", out conditionsObject) )
			{
				throw new Exception("Error parsing 'weather' from conditionsObject");
			}
			string conditions = (String)conditionsObject;

			object temperatureObject = new Object();
			if ( !currentObservation.TryGetValue("temperature_string", out temperatureObject) )
			{
				throw new Exception("Error parsing 'temperature_string' from conditionsObject");
			}
			string temperature = (String)temperatureObject;

			object lastObservationObject = new Object();
			if ( !currentObservation.TryGetValue("observation_time", out lastObservationObject) )
			{
				throw new Exception("Error parsing 'observation_time' from conditionsObject");
			}
			string lastObservation = (String)lastObservationObject;

			Console.WriteLine( Environment.NewLine + Environment.NewLine + 
				"Weather as of: " + lastObservation + Environment.NewLine +
				"Conditions: " + conditions + Environment.NewLine +
				"Temperature: " + temperature + Environment.NewLine + Environment.NewLine);
		}
	}
}

public class TwitterWeather
{
  static void Main(string[] args)
  {
  	string profileName = "TheScienceGuy";
  	if( args.Length > 0)
  	{
  		profileName = (String)args[0];
  	}

  	TW.Twitter twitter = new TW.Twitter();
  	Dictionary<string, object> profileJson = twitter.GetProfile(profileName);
  	string location = twitter.GetLocation(profileJson);

  	TW.Weather weather = new TW.Weather();
  	Dictionary<string, object> weatherJson = weather.GetWeather(location);
  	weather.PrintWeather(weatherJson);

  }
}





