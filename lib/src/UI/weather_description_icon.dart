import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';


IconData mapDescriptionToIcon(String description) {
    switch (description.toLowerCase()) {
      case 'clear sky':
        return WeatherIcons.day_sunny;
      case 'few clouds':
        return WeatherIcons.day_cloudy;
      case 'scattered clouds':
        return WeatherIcons.cloud;
      case 'broken clouds':
        return WeatherIcons.cloudy;
      case 'overcast clouds':
        return WeatherIcons.cloudy;
      case 'shower rain':
        return WeatherIcons.showers;
      case 'rain':
        return WeatherIcons.rain;
      case 'thunderstorm':
        return WeatherIcons.thunderstorm;
      case 'snow':
        return WeatherIcons.snow;
      case 'mist':
        return WeatherIcons.fog;
      case 'light rain':
        return WeatherIcons.rain_mix;
      case 'moderate rain':
        return WeatherIcons.rain_wind;
      case 'heavy intensity rain':
        return WeatherIcons.rain;
      case 'very heavy rain':
        return WeatherIcons.rain;
      case 'extreme rain':
        return WeatherIcons.rain;
      case 'light snow':
        return WeatherIcons.snowflake_cold;
      case 'heavy snow':
        return WeatherIcons.snow;
      case 'sleet':
        return WeatherIcons.sleet;
      case 'shower sleet':
        return WeatherIcons.rain_mix;
      case 'light rain and snow':
        return WeatherIcons.rain_mix;
      case 'rain and snow':
        return WeatherIcons.rain_mix;
      case 'light shower snow':
        return WeatherIcons.snowflake_cold;
      case 'shower snow':
        return WeatherIcons.snow;
      case 'heavy shower snow':
        return WeatherIcons.snow;
      case 'smoke':
        return WeatherIcons.smoke;
      case 'haze':
        return WeatherIcons.day_haze;
      case 'sand/dust whirls':
        return WeatherIcons.sandstorm;
      case 'fog':
        return WeatherIcons.fog;
      case 'sand':
        return WeatherIcons.sandstorm;
      case 'dust':
        return WeatherIcons.dust;
      case 'volcanic ash':
        return WeatherIcons.volcano;
      case 'squalls':
        return WeatherIcons.strong_wind;
      case 'tornado':
        return WeatherIcons.tornado;
      case 'cold':
        return WeatherIcons.snowflake_cold;
      case 'hot':
        return WeatherIcons.hot;
      case 'windy':
        return WeatherIcons.strong_wind;
      case 'hail':
        return WeatherIcons.hail;
      case 'drizzle':
        return WeatherIcons.sprinkle;
      case 'light intensity drizzle':
        return WeatherIcons.sprinkle;
      case 'heavy intensity drizzle':
        return WeatherIcons.showers;
      case 'thunderstorm with light rain':
        return WeatherIcons.thunderstorm;
      case 'thunderstorm with rain':
        return WeatherIcons.thunderstorm;
      case 'thunderstorm with heavy rain':
        return WeatherIcons.thunderstorm;
      case 'light intensity shower rain':
        return WeatherIcons.showers;
      case 'heavy intensity shower rain':
        return WeatherIcons.showers;
      case 'ragged shower rain':
        return WeatherIcons.showers;
      case 'thunderstorm with light drizzle':
        return WeatherIcons.thunderstorm;
      case 'thunderstorm with drizzle':
        return WeatherIcons.thunderstorm;
      case 'thunderstorm with heavy drizzle':
        return WeatherIcons.thunderstorm;
      // ... add more mappings as needed
      default:
        return WeatherIcons.na; // Or a suitable default icon
    }
  }
