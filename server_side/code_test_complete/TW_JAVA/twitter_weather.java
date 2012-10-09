import java.net.HttpURLConnection;  
import java.net.URL;  
import java.net.URLEncoder;
import java.net.MalformedURLException;  
import java.io.IOException;  
import java.io.*;
import org.json.simple.*;
import org.json.simple.parser.*;

class TW
{
	static class Config
	{
		// 	http://twitter.com/users/<Twitter Profile>.json
		public static final String twitter_api_url = "http://twitter.com/users";
		//  http://api.wunderground.com/api/c8d687c53a5511dd/conditions/q/<STATE ABBR>/<CITY>.json
		public static final String weather_api_url = "http://api.wunderground.com/api/c8d687c53a5511dd/conditions/q";
	}

	static class Util
	{
		public static String GetUrl(String url)
		{
			HttpURLConnection urlConn = null;  
		    BufferedReader br;  
		   	String buffer, result = "";
		    try
		    {  
		    	//start web request
				URL new_url = new URL(url);  
				urlConn = (HttpURLConnection)new_url.openConnection();  
				urlConn.setRequestMethod("GET");  
				urlConn.setDoInput (true);  
				urlConn.setDoOutput (true);  
				urlConn.setRequestProperty ("Content-Type","application/x-www-form-urlencoded");  

				br = new BufferedReader(new InputStreamReader(urlConn.getInputStream()));  
				while ((buffer = br.readLine()) != null) 
				{
					result = result + buffer;
				}		   
				//web request finished
		    }catch(MalformedURLException e){  
		   		System.out.println(e.getMessage());  
		      	System.out.println(e.getStackTrace());
		    }catch(IOException e){  
		    	System.out.println(e.getMessage());  
		      	System.out.println(e.getStackTrace());
		    }catch(Exception e){  
				System.out.println(e.getMessage());  
				System.out.println(e.getStackTrace());  
		    } 
		    return result;
		}

		public static JSONObject ProcessJsonResponse(String json_response)
		{
			Object obj=JSONValue.parse(json_response);
			JSONObject json_profile=(JSONObject)obj;
	    	return json_profile;
	    }
	}

	class Twitter
	{
		public JSONObject GetProfile(String profile_name)
		{
			String url = TW.Config.twitter_api_url + "/" + profile_name + ".json";
			String json_response = TW.Util.GetUrl(url);
			return TW.Util.ProcessJsonResponse( json_response );
		}

		public String GetLocation(JSONObject profile_json)
		{
			String location = (String)profile_json.get("location");
			return location;
		}
	}

	class Weather
	{
		public JSONObject GetWeather(String user_location)
		{
			String delimiter = ",";
			String[] location_array = user_location.split(delimiter);
			String city = location_array[0].replaceAll("^\\s+", "").replaceAll("\\s+$", "").replaceAll(" ", "%20");
			String state = location_array[1].replaceAll("^\\s+", "").replaceAll("\\s+$", "");
			

			String weather_url = TW.Config.weather_api_url+"/"+state+"/"+city+".json";
			String json_response = TW.Util.GetUrl(weather_url);
			return TW.Util.ProcessJsonResponse(json_response);
		}

		public void PrintWeather(JSONObject weather_json)
		{

			JSONObject current_observation = (JSONObject)weather_json.get("current_observation");
			String conditions = (String)current_observation.get("weather");
			String temperature = (String)current_observation.get("temperature_string");
			String last_observation = (String)current_observation.get("observation_time");

			String newLine = System.getProperty("line.separator");
			System.out.println( newLine + newLine + 
				"Weather as of: " + last_observation + newLine +
				"Conditions: " + conditions + newLine +
				"Temperature: " + temperature + newLine + newLine);
		}
	}

}

public class twitter_weather 
{ 
   	public static void main(String[] args) 
   	{ 
   		String profile_name = "TheScienceGuy";
   		if (args.length > 0) 
   		{
			try
			{
				profile_name = (String)(args[0]);
			} catch (Exception e){
				System.out.println(e.getMessage());
			}

   		}

   		TW tw = new TW();
        TW.Twitter twitter = tw.new Twitter();
        JSONObject profile_json = twitter.GetProfile(profile_name);
        String location = twitter.GetLocation(profile_json);

        TW.Weather weather = tw.new Weather();
        JSONObject weather_json = weather.GetWeather(location);
        weather.PrintWeather(weather_json);
   	}
}	
