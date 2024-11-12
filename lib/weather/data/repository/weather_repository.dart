import 'package:dio/dio.dart';
import '../models/weather_model.dart';

class WeatherRepository {
  final Dio _dio = Dio();
  final String _apiKey = '5a6c17f7e5f94ff09bf180911242910';
  final String _baseUrl = 'http://api.weatherapi.com/v1/current.json';

  /// Fetch weather data by city name
  Future<WeatherModel> getWeatherByCity(String city) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'key': _apiKey,
          'q': city,
          'lang': 'it',
          'aqi': 'no',
        },
      );

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Error fetching weather data for city: $e');
    }
  }

  /// Fetch weather data by latitude and longitude
  Future<WeatherModel> getWeatherByCoordinates(
      double latitude, double longitude) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'key': _apiKey,
          'q': '$latitude,$longitude',
          'lang': 'it',
          'aqi': 'no',
        },
      );

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Error fetching weather data for coordinates: $e');
    }
  }
}
