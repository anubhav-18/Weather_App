import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/apikey.dart';
import 'package:weather_app/src/models/daily_forecast_model.dart';
import 'package:weather_app/src/models/weather_model.dart';
import 'package:weather_app/src/reusable_widget/custom_snackbar.dart';
import 'geolocation.dart';
import 'package:http/http.dart' as http;

Future<WeatherModel> callToApi(
    bool current, String cityName, BuildContext context) async {
  try {
    String apiUrl;

    if (current) {
      // Fetch the current location of the user
      Position currentPosition = await getLocation(context);

      // Get placemark (address details) from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude,
          localeIdentifier: 'en_US');
      print(
          "Latitude: ${currentPosition.latitude}, Longitude: ${currentPosition.longitude}");

      if (placemarks.isEmpty) {
        throw ("No placemarks found for the current location");
      }

      // Fetch the city name from placemarks
      Placemark place = placemarks.first;
      cityName = place.locality ??
          place.subLocality ??
          place.subAdministrativeArea ??
          "Unknown Location";
      print("Fetched City: $cityName");

      // Construct API URL using current location coordinates
      apiUrl =
          "https://api.openweathermap.org/data/2.5/weather?lat=${currentPosition.latitude}&lon=${currentPosition.longitude}&appid=$apiKey&units=metric";
    } else {
      // Construct API URL using the city name
      apiUrl =
          "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric";
    }

    // Make HTTP GET request to fetch weather data
    final http.Response response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Parse JSON response
      final Map<String, dynamic> decodedJson = json.decode(response.body);

      // Fetch additional data (UV index and air pollution) using coordinates
      final double latitude = decodedJson['coord']['lat'];
      final double longitude = decodedJson['coord']['lon'];
      final uvIndex = await fetchUVIndex(latitude, longitude);
      decodedJson['uvi'] = uvIndex;

      // Fetch air pollution data
      final airPollutionApiUrl =
          'http://api.openweathermap.org/data/2.5/air_pollution?lat=$latitude&lon=$longitude&appid=$apiKey';
      final airPollutionResponse =
          await http.get(Uri.parse(airPollutionApiUrl));
      if (airPollutionResponse.statusCode == 200) {
        final airPollutionData = json.decode(airPollutionResponse.body);
        decodedJson['airPollution'] = airPollutionData['list'][0];
      } else {
        print(
            'Failed to fetch air pollution data: ${airPollutionResponse.statusCode}');
      }
      decodedJson['isCurrentLocation'] = current;
      return WeatherModel.fromMap(decodedJson);
    } else if (response.statusCode == 404) {
      // Handle city not found error
      showCustomSnackBar(context, 'City not found: $cityName', isError: true);
      return WeatherModel.errorInstance(
          errorMessage: 'City not found: $cityName');
    } else {
      // Handle other errors
      showCustomSnackBar(context,
          'Failed to fetch weather data. Please try again later.', isError: true);
      return WeatherModel.errorInstance(
          errorMessage: 'Failed to fetch weather data');
    }
  } on SocketException {
    // Handle no internet connection error
    showCustomSnackBar(context,
        'No internet connection. Please check your network settings.', isError: true);
    return WeatherModel.errorInstance(errorMessage: 'No internet connection');
  } on FormatException {
    // Handle invalid data format error
    showCustomSnackBar(context,
        'Invalid data format received from the server.', isError: true);
    return WeatherModel.errorInstance(errorMessage: 'Invalid response format');
  } on TimeoutException {
    // Handle request timeout error
    showCustomSnackBar(
        context, 'Request timed out. Please try again later.', isError: true);
    return WeatherModel.errorInstance(errorMessage: 'Request timeout');
  } catch (e) {
    // Handle unexpected errors
    showCustomSnackBar(
        context, 'An unexpected error occurred. Please try again later.', isError: true);
    return WeatherModel.errorInstance(errorMessage: 'Failed to fetch data.');
  }
}

// Fetch UV Index using coordinates
Future<double> fetchUVIndex(double latitude, double longitude) async {
  final apiUrl =
      'http://api.openweathermap.org/data/2.5/uvi?lat=$latitude&lon=$longitude&appid=$apiKey';

  final response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['value'].toDouble();
  } else {
    throw Exception('Failed to fetch UV index');
  }
}

// Fetch five-day weather forecast for a city
Future<List<DailyForecast>> fetchFiveDayForecast(
    String cityName, BuildContext context) async {
  final apiUrl =
      'http://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$apiKey&units=metric';

  final response = await http.get(Uri.parse(apiUrl));
  print("5 DAY Forecast: ${response.statusCode}");

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    final List<dynamic> forecastList = jsonData['list'];

    // Group forecasts by day
    final Map<String, List<Map<String, dynamic>>> forecastsByDay = {};
    for (final forecast in forecastList) {
      final dateString = DateFormat('yyyy-MM-dd')
          .format(DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000));
      forecastsByDay.putIfAbsent(dateString, () => []);
      forecastsByDay[dateString]!.add(forecast);
    }

    // Calculate average temperature and get the last forecast for each day
    return forecastsByDay.values.map((dailyForecasts) {
      final tempSum = dailyForecasts.fold<double>(
          0, (sum, forecast) => sum + forecast['main']['temp']);
      final avgTemp = tempSum / dailyForecasts.length;
      return DailyForecast.fromMap({
        ...dailyForecasts.last, // Use last forecast for icon, description, etc.
        'main': {'temp': avgTemp} // Set average temperature
      });
    }).toList();
  } else {
    // Handle error when fetching forecast data
    showCustomSnackBar(
        context, 'Failed to fetch forecast data. Please try again later.');
    return [];
  }
}
