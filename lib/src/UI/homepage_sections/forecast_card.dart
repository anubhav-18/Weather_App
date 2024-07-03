import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/constants.dart';
import 'package:weather_app/src/UI/weather_description_icon.dart';
import 'package:weather_app/src/provider/weather_provider.dart';
import '../../models/daily_forecast_model.dart';
import 'package:weather_icons/weather_icons.dart';

class ForecastCard extends StatelessWidget {
  final DailyForecast forecast;

  const ForecastCard({
    Key? key,
    required this.forecast,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final weatherData = Provider.of<WeatherProvider>(context, listen: false);
    final dayOfWeek = DateFormat('E').format(forecast.date);
    final formattedDate = DateFormat('dd/MM').format(forecast.date);
    final isToday =
        DateTime.now().day == forecast.date.day; // Check if it's today
    final isTomorrow = DateTime.now().add(const Duration(days: 1)).day ==
        forecast.date.day; // Check if it's tomorrow

    String dayLabel = dayOfWeek;
    if (isToday) {
      dayLabel = 'Today';
    } else if (isTomorrow) {
      dayLabel = 'Tomorrow';
    }

    return Card(
      elevation: 2,
      color: secondaryBckgnd, // Make the card transparent
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(12.0), // Adjust padding as needed
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dayLabel,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Text(
              formattedDate, // Display date if not today/tomorrow
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 10),
            BoxedIcon(
              mapDescriptionToIcon(forecast.description),
              color: whiteColor,
              size: 35, // Adjust icon size as needed
            ), // Custom icon widget
            const SizedBox(height: 10),
            Text(
              weatherData.selectedUnit == 'Celsius (\u00B0C)'
                  ? '${forecast.temp.toInt()}\u00B0C'
                  : '${((forecast.temp * 9 / 5) + 32).toInt()}\u00B0F',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}
