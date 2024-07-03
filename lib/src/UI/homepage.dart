import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/constants.dart';
import 'package:weather_app/src/UI/homepage_sections/air_pollution_card.dart';
import 'package:weather_app/src/UI/homepage_sections/forecast_card.dart';
import 'package:weather_app/src/UI/homepage_sections/sunrise_sunset_card.dart';
import 'package:weather_app/src/UI/homepage_sections/weather_screen_info.dart';
import 'package:weather_app/src/models/daily_forecast_model.dart';
import 'package:weather_app/src/models/weather_model.dart';
import 'package:weather_app/src/provider/weather_provider.dart';
import 'package:weather_app/src/services/call_to_api.dart';
import 'package:weather_app/src/services/geolocation.dart';

class WeatherHome extends StatefulWidget {
  final String? location; // Location parameter for specifying a location
  const WeatherHome({super.key, this.location});

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  WeatherModel? _weatherData; // Holds the current weather data
  String _selectedCity = ""; // Stores the selected city name
  bool _isLoading = true; // Indicates if data is currently being fetched
  String _appBarTitle = 'Weather'; // Title for the app bar
  List<DailyForecast> _forecastData = []; // Stores the 5-day forecast data

  @override
  void initState() {
    super.initState();
    _selectedCity =
        Provider.of<WeatherProvider>(context, listen: false).selectedCity ??
            ""; // Initialize selected city from provider
    print(
        'Loaded Selected City: $_selectedCity'); // Debug print for selected city
    _fetchInitialWeatherData(); // Fetch initial weather data on screen load
  }

  Future<void> _fetchInitialWeatherData() async {
    try {
      // Fetch data ONLY if a selectedCity exists
      if (_selectedCity.isNotEmpty) {
        _weatherData = await getData(false, _selectedCity);
        await _fetchForecastData(_selectedCity); // Fetch forecast data
      } else {
        Position currentPosition =
            await getLocation(context); // Get current device location
        _weatherData = await getData(
            true, ""); // Fetch weather data based on current location
        _selectedCity = _weatherData!.city; // Update selected city
        await _fetchForecastData(_selectedCity); // Fetch forecast data
        if (mounted) {
          Provider.of<WeatherProvider>(context, listen: false)
              .setSelectedCity(_selectedCity); // Set selected city in provider
        }
      }
      if (_weatherData!.errorMessage != null) {
        // Check for error message from API
      } else {
        _fetchForecastData(
            _selectedCity); // Only fetch forecast if weather data is valid
      }
      setState(() {
        _appBarTitle = _selectedCity; // Update app bar title with city name
        _isLoading = false; // Update loading state
      });
    } catch (e) {
      print(
          "Error getting weather data: $e"); // Handle errors in fetching weather data
      // Handle errors
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true; // Start loading immediately
    });

    await Future.delayed(const Duration(seconds: 3)); // Simulate delay

    setState(() {
      _isLoading = false; // Stop loading after the delay
    });
  }

  void _fetchWeatherData(String cityName) async {
    setState(() {
      _isLoading = true; // Set loading state
    });

    WeatherModel data = await getData(
        cityName.isEmpty, cityName); // Fetch weather data for specified city
    setState(() {
      _weatherData = data; // Update weather data
      _appBarTitle = data.city; // Update app bar title with city name
      _isLoading = false; // Update loading state
    });
  }

  Future<void> _fetchForecastData(String cityName) async {
    try {
      final forecastData = await fetchFiveDayForecast(
          cityName, context); // Fetch 5-day forecast data
      setState(() {
        _forecastData = forecastData; // Update forecast data
      });
    } catch (e) {
      print(
          "Error fetching forecast data: $e"); // Handle errors in fetching forecast data
      // Handle the error
    }
  }

  Future<WeatherModel> getData(bool isCurrentCity, String cityName) async {
    return await callToApi(
        isCurrentCity, cityName, context); // Call API to fetch weather data
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height; // Get screen height

    return Consumer<WeatherProvider>(
      builder: (context, weatherProvider, child) {
        final selectedCity = weatherProvider.selectedCity ??
            ""; // Get selected city from provider
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              _appBarTitle.isNotEmpty
                  ? _appBarTitle
                  : "Weather", // Display app bar title
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  final result = await Navigator.pushNamed(
                      context, '/search'); // Navigate to search screen
                  if (result != null && result is String) {
                    Provider.of<WeatherProvider>(context, listen: false)
                        .setSelectedCity(
                            result); // Set selected city from search result
                    _fetchWeatherData(
                        result); // Fetch weather data for new city
                  }
                },
                icon: const Icon(
                  Icons.search, // Search icon
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pushNamed(
                    context, '/setting'), // Navigate to settings screen
                icon: const Icon(
                  Icons.more_vert, // More options icon
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: _isLoading
                ? Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Weather Loading ...', // Loading indicator
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(width: 10),
                        const CircularProgressIndicator(
                            color: whiteColor), // Loading spinner
                      ],
                    ),
                  )
                : (_weatherData == null)
                    ? const Center(
                        child: Text(
                          'Error Fetching Weather', // Error message when weather data is null
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _refreshData, // Refresh indicator callback
                        backgroundColor: whiteColor,
                        color: primaryBckgnd,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    BuildWeatherScreen(
                                        height: height,
                                        data:
                                            _weatherData!), // Weather screen UI
                                    if (_forecastData.isNotEmpty) ...[
                                      const SizedBox(height: 20),
                                      SizedBox(
                                        height: 180, // Adjust height as needed
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: _forecastData.length,
                                          itemBuilder: (context, index) {
                                            final forecast = _forecastData[
                                                index]; // Forecast card UI
                                            return ForecastCard(
                                              forecast: forecast,
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                    if (_weatherData!.airPollution != null) ...[
                                      const SizedBox(height: 20),
                                      AirPollutionCard(
                                          data: _weatherData!
                                              .airPollution!), // Air pollution UI
                                    ],
                                    const SizedBox(height: 20),
                                    SunriseSunsetCard(
                                        data:
                                            _weatherData!), // Sunrise sunset UI
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
          ),
        );
      },
    );
  }
}
