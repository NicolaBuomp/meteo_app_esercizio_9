import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meteo_app_esercizio_9/weather/data/models/weather_model.dart';
import '../data/repository/weather_repository.dart';

final weatherRepositoryProvider =
    FutureProvider.family<WeatherModel, String>((ref, cityName) async {
  final repository = WeatherRepository();
  return await repository.getWeatherByCity(cityName);
});
