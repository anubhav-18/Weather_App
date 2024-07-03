class DailyForecast {
  final DateTime date;
  final double tempMin;
  final double tempMax;
  final double temp; // Average temperature
  final String icon;
  final String description;
  final int humidity;
  final double windSpeed;
  final int windDeg; // Wind direction in degrees
  final double pop; // Probability of precipitation
  final int clouds;
  final double rain; // Rain volume for the last 3 hours (if available)
  final double snow; // Snow volume for the last 3 hours (if available)

  DailyForecast({
    required this.date,
    required this.tempMin,
    required this.tempMax,
    required this.temp,
    required this.icon,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.windDeg,
    required this.pop,
    required this.clouds,
    required this.rain,
    required this.snow,
  });

  factory DailyForecast.fromMap(Map<String, dynamic> map) {
    final main = map['main'] as Map<String, dynamic>?;
    final weather =
        (map['weather'] as List?)?.firstOrNull as Map<String, dynamic>?;
    final wind = map['wind'] as Map<String, dynamic>?;
    final clouds = map['clouds'] as Map<String, dynamic>?;
    final rain = map['rain'] as Map<String, dynamic>?;
    final snow = map['snow'] as Map<String, dynamic>?;

    return DailyForecast(
      date: DateTime.fromMillisecondsSinceEpoch(map['dt'] * 1000),
      tempMin: (main?['temp_min'] as num?)?.toDouble() ?? 0.0,
      tempMax: (main?['temp_max'] as num?)?.toDouble() ?? 0.0,
      temp: (main?['temp'] as num?)?.toDouble() ?? 0.0,
      icon: weather?['icon'] as String? ?? '',
      description: weather?['description'] as String? ?? '',
      humidity: (main?['humidity'] as num?)?.toInt() ?? 0,
      windSpeed: (wind?['speed'] as num?)?.toDouble() ?? 0.0,
      windDeg: (wind?['deg'] as num?)?.toInt() ?? 0,
      pop: (map['pop'] as num?)?.toDouble() ?? 0.0,
      clouds: (clouds?['all'] as num?)?.toInt() ?? 0,
      rain: (rain?['3h'] as num?)?.toDouble() ?? 0.0,
      snow: (snow?['3h'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
