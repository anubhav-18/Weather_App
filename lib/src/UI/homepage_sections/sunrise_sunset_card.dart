import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/constants.dart';
import '../../models/weather_model.dart';
import 'dart:math';

class SunriseSunsetCard extends StatelessWidget {
  final WeatherModel data;

  const SunriseSunsetCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sunrise = DateTime.fromMillisecondsSinceEpoch(data.sunrise * 1000);
    final sunset = DateTime.fromMillisecondsSinceEpoch(data.sunset * 1000);
    final currentTime = DateTime.now();

    final totalMinutes = sunset.difference(sunrise).inMinutes;
    final elapsedMinutes = currentTime.difference(sunrise).inMinutes;
    final progress = elapsedMinutes / totalMinutes;

    return Card(
      elevation: 4, // Add some elevation for a subtle shadow
      color: secondaryBckgnd,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomPaint(
              painter:
                  SunriseSunsetPainter(progress: min(max(progress, 0.0), 1.0)),
              size: const Size(280, 140), // Adjust the size as needed
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                _buildTimeItem(Icons.wb_sunny_outlined, 'Sunrise',
                    DateFormat.jm().format(sunrise)),
                const Spacer(),
                _buildTimeItem(
                    Icons.wb_sunny, 'Sunset', DateFormat.jm().format(sunset)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeItem(IconData icon, String label, String time) {
    return Column(
      children: [
        Icon(icon, color: Colors.orange),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 4),
        Text(time, style: const TextStyle(fontSize: 16, color: Colors.white)),
      ],
    );
  }
}

class SunriseSunsetPainter extends CustomPainter {
  final double progress;

  SunriseSunsetPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paintCovered = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;

    final paintUncovered = Paint()
      ..color = whiteColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;
    
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;

    // Draw the semi-circle
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi, // Start angle
      pi, // Sweep angle
      false,
      paintUncovered,
    );

    // Draw the covered part of the semi-circle
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi, // Start angle
      pi * progress, // Sweep angle based on progress
      false,
      paintCovered,
    );

    // Draw the moving sun
    final angle = pi * progress;
    final sunX = center.dx + radius * cos(angle - pi);
    final sunY = center.dy + radius * sin(angle - pi);
    canvas.drawCircle(
        Offset(sunX, sunY), 10, paintCovered..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
