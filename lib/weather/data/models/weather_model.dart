class WeatherModel {
  final String location;
  final String localtime;
  final double temperature;
  final String condition;
  final String iconUrl;
  final int humidity;
  final double windSpeed;

  WeatherModel({
    required this.location,
    required this.localtime,
    required this.temperature,
    required this.condition,
    required this.iconUrl,
    required this.humidity,
    required this.windSpeed,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      location: json['location']['name'] ?? '',
      localtime: json['location']['localtime'] ?? '',
      temperature: json['current']['temp_c'] ?? 0.0,
      condition: json['current']['condition']['text'] ?? '',
      iconUrl: "https:${json['current']['condition']['icon'] ?? ''}",
      humidity: json['current']['humidity'] ?? 0,
      windSpeed: json['current']['wind_kph'] ?? 0.0,
    );
  }
}
