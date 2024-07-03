class AirPollutionData {
  final int aqi;
  final double pm2_5;
  final double pm10;
  final double co;
  final double so2;

  AirPollutionData({
    required this.aqi,
    required this.pm2_5,
    required this.pm10,
    required this.co,
    required this.so2,
  });

  factory AirPollutionData.fromMap(Map<String, dynamic> map) {
    return AirPollutionData(
      aqi: map['main']['aqi'],
      pm2_5: map['components']['pm2_5'],
      pm10: map['components']['pm10'],
      co: map['components']['co'],
      so2: map['components']['so2'],
    );
  }
}
