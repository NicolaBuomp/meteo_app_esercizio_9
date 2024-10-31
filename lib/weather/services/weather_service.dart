import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/weather_model.dart';

class WeatherService {
  static const String _cacheWeatherData = 'cachedWeatherData';

  Future<void> saveWeatherData(WeatherModel weather) async {
    final prefs = await SharedPreferences.getInstance();
    final weatherData = jsonEncode({
      'location': weather.location,
      "region": weather.region,
      "country": weather.country,
      'localtime': weather.localtime,
      'temperature': weather.temperature,
      'condition': weather.condition,
      'iconUrl': weather.iconUrl,
      'humidity': weather.humidity,
      'windSpeed': weather.windSpeed,
    });
    await prefs.setString(_cacheWeatherData, weatherData);
  }

  Future<WeatherModel?> getWeatherData() async {
    final prefs = await SharedPreferences.getInstance();
    final weatherData = prefs.getString(_cacheWeatherData);
    if (weatherData != null) {
      final json = jsonDecode(weatherData);
      return WeatherModel(
        location: json['location'],
        region: json['region'],
        country: json['country'],
        localtime: json['localtime'],
        temperature: json['temperature'],
        condition: json['condition'],
        iconUrl: json['iconUrl'],
        humidity: json['humidity'],
        windSpeed: json['windSpeed'],
      );
    }
    return null;
  }

  Future<void> clearWeatherCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheWeatherData);
  }
}
