import 'package:flutter/material.dart';
import 'package:weather_app/constants.dart';
import 'package:weather_app/src/models/air_pollution_model.dart';

class AirPollutionCard extends StatelessWidget {
  final AirPollutionData data;

  const AirPollutionCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Adjust the elevation value as needed
      color: secondaryBckgnd,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AQI Text and Progress Bar
            _buildAQITextAndProgressBar(data.pm2_5.toInt(), context),
            const SizedBox(height: 20),
            // Pollutant Labels and Values
            _buildPollutantRow(
              'PM2.5',
              data.pm2_5.toInt().toString(),
              Colors.yellow,
              context,
            ),
            _buildPollutantRow(
              'PM10',
              data.pm10.toInt().toString(),
              Colors.lightGreen,
              context,
            ),
            _buildPollutantRow(
              'CO',
              data.co.toInt().toString(),
              Colors.orange,
              context,
            ),
            _buildPollutantRow(
              'SO2',
              data.so2.toInt().toString(),
              Colors.lightGreen,
              context,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAQITextAndProgressBar(int aqi, BuildContext context) {
    String aqiText;
    Color aqiColor;
    double progress;

    if (aqi <= 50) {
      aqiText = 'Good';
      aqiColor = Colors.green;
      progress = aqi / 100;
    } else if (aqi <= 100) {
      aqiText = 'Moderate';
      aqiColor = Colors.yellow;
      progress = aqi / 100;
    } else if (aqi <= 150) {
      aqiText = 'Unhealthy for Sensitive Groups';
      aqiColor = Colors.orange;
      progress = aqi / 100;
    } else if (aqi <= 200) {
      aqiText = 'Unhealthy';
      aqiColor = Colors.red;
      progress = aqi / 100;
    } else if (aqi <= 300) {
      aqiText = 'Very Unhealthy';
      aqiColor = Colors.purple;
      progress = aqi / 100;
    } else {
      aqiText = 'Hazardous';
      aqiColor = const Color.fromARGB(255, 89, 6, 1);
      progress = 1.0;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Air Quality Index (AQI):',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: whiteColor,
              ),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$aqi',
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: whiteColor,
                    fontSize: 50,
                    height: 0.9,
                  ),
            ),
            const SizedBox(width: 10),
            Text(
              aqiText,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: aqiColor,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[700],
          valueColor: AlwaysStoppedAnimation<Color>(aqiColor),
          minHeight: 8,
        ),
      ],
    );
  }

  Widget _buildPollutantRow(
      String label, String value, Color color, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: whiteColor,
                ),
          ),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: color,
                ),
          ),
        ],
      ),
    );
  }
}
