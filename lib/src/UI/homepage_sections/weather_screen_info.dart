import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/constants.dart';
import 'package:weather_app/src/UI/weather_description_icon.dart';
import 'package:weather_app/src/models/weather_model.dart';
import 'package:weather_app/src/provider/weather_provider.dart';
import 'package:weather_icons/weather_icons.dart';

class BuildWeatherScreen extends StatefulWidget {
  const BuildWeatherScreen({
    super.key,
    required this.height,
    required this.data,
  });

  final double height;
  final WeatherModel data;

  @override
  State<BuildWeatherScreen> createState() => BuildWeatherScreenState();
}

class BuildWeatherScreenState extends State<BuildWeatherScreen> {
  @override
  Widget build(BuildContext context) {
    final iconData = mapDescriptionToIcon(widget.data.desc);
    final weatherData = Provider.of<WeatherProvider>(context, listen: false);

    return Column(
      children: [
        // Display the weather icon
        BoxedIcon(
          iconData,
          color: whiteColor,
          size: 80, // Adjust icon size as needed
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 50),
            Text(
              // '${widget.data.temp.toInt()}',
              weatherData.selectedUnit == 'Celsius (\u00B0C)'
                  ? '${widget.data.temp.toInt()}'
                  : '${((widget.data.temp * 9 / 5) + 32).toInt()}',
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    fontSize: 120,
                    height: 1,
                  ),
            ),
            Text(
              weatherData.selectedUnit == 'Celsius (\u00B0C)'
                  ? '\u00B0C'
                  : '\u00B0F',
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    fontSize: 40,
                    color: greycolor2,
                  ),
            ),
          ],
        ),
        Text(
          widget.data.desc,
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                fontSize: 22,
                color: whiteColor,
              ),
        ),
        const SizedBox(height: 20),
        Card(
          elevation: 4, // Adjust the elevation value as needed
          color: secondaryBckgnd,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(26.0), // Add padding inside the card
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    weatherInfo(
                      Icons.thermostat,
                      'Feels like',
                      weatherData.selectedUnit == 'Celsius (\u00B0C)'
                          ? '${widget.data.feelsLike.toInt()}\u00B0C'
                          : '${((widget.data.feelsLike * 9 / 5) + 32).toInt()}\u00B0F',
                      context,
                    ),
                    weatherInfo(
                      Icons.air,
                      'Wind',
                      '${widget.data.windSpeed} m/s',
                      context,
                    ),
                    weatherInfo(
                      Icons.water_drop,
                      'Humidity',
                      '${widget.data.humidity}%',
                      context,
                    ),
                  ],
                ),
                const SizedBox(height: 20), // Add spacing between the rows
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    weatherInfo(
                      Icons.wb_sunny,
                      'UV Index',
                      widget.data.uvIndex.toString(),
                      context,
                    ),
                    weatherInfo(
                      Icons.visibility,
                      'Visibility',
                      '${widget.data.visibilityKm} Km',
                      context,
                    ),
                    weatherInfo(
                      Icons.speed,
                      'Pressure',
                      '${widget.data.pressure} hPa',
                      context,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget weatherInfo(
    IconData icon,
    String label,
    String value,
    BuildContext context,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: iconColor,
          size: 28,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: greycolor2,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: whiteColor,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}
