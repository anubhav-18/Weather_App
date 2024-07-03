import 'package:weather_app/src/models/air_pollution_model.dart';

class WeatherModel {
  late double temp;
  late String city;
  late String desc;
  late String windSpeed;
  late String windDirection;
  late String humidity;
  late String pressure;
  late String visibility;
  late int sunrise;
  late int sunset;
  late double feelsLike;
  late double uvIndex;
  late String precipitationProbability;
  late int visibilityKm;
  late double latitude;
  late double longitude;
  AirPollutionData? airPollution;
  String? errorMessage;

  WeatherModel.fromMap(Map<String, dynamic> json) {
    temp = json['main']['temp'];
    city = json['name'];
    desc = json['weather'][0]['description'];
    windSpeed = json['wind']['speed'].toString();
    windDirection = json['wind']['deg'].toString();
    humidity = json['main']['humidity'].toString();
    pressure = json['main']['pressure'].toString();
    visibility = json['visibility'].toString();
    visibilityKm = int.parse(visibility) ~/ 1000;
    sunrise = json['sys']['sunrise'];
    sunset = json['sys']['sunset'];
    feelsLike = json['main']['feels_like'];
    uvIndex = json['uvi'].toDouble();
    precipitationProbability = json['pop'].toString();
    latitude = json['coord']['lat'];
    longitude = json['coord']['lon'];
    airPollution = (json['airPollution'] != null)
        ? AirPollutionData.fromMap(json['airPollution'])
        : null;
    errorMessage = null;
  }
  WeatherModel.errorInstance({required this.errorMessage})
      : temp = 0.0,
        city = '',
        desc = '',
        windSpeed = '0',
        windDirection = '0',
        humidity = '0',
        pressure = '0',
        visibility = '0',
        visibilityKm = 0,
        sunrise = 0,
        sunset = 0,
        feelsLike = 0.0,
        uvIndex = 0.0,
        precipitationProbability = '0',
        latitude = 0.0,
        longitude = 0.0,
        airPollution = null;
}
