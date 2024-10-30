import 'package:dio/dio.dart';
import '../models/weather_model.dart';

class WeatherRepository {
  final Dio _dio = Dio();
  final String _apiKey = '5a6c17f7e5f94ff09bf180911242910';
  final String _baseUrl = 'http://api.weatherapi.com/v1/current.json';

  Future<WeatherModel> fetchWeather(String city) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'key': _apiKey,
          'q': city,
          'aqi': 'no',
        },
      );

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Error fetching weather data: $e');
    }
  }
}
