import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meteo_app_esercizio_9/weather/di/weather_provider.dart';
import '../data/models/weather_model.dart';
import '../data/repository/weather_repository.dart';
import '../services/weather_service.dart';

class WeatherViewModel extends StateNotifier<AsyncValue<WeatherModel?>> {
  final WeatherRepository _repository;
  final WeatherService _service;

  WeatherViewModel(this._repository, this._service)
      : super(const AsyncValue.loading()) {
    _loadCachedWeather();
  }

  Future<void> _loadCachedWeather() async {
    try {
      final cachedWeather = await _service.getWeatherData();
      if (cachedWeather != null) {
        state = AsyncValue.data(cachedWeather);
      } else {
        state = const AsyncValue.data(null);
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> loadWeather(String city) async {
    try {
      state = const AsyncValue.loading();
      final weather = await _repository.fetchWeather(city);
      await _service.saveWeatherData(weather);
      state = AsyncValue.data(weather);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> loadWeatherByLocation(double latitude, double longitude) async {
    try {
      state = const AsyncValue.loading();
      final weather =
          await _repository.fetchWeatherLatLong(latitude, longitude);
      await _service.saveWeatherData(weather);
      state = AsyncValue.data(weather);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> refreshWeather() async {
    final currentWeather = state.value;
    if (currentWeather != null) {
      await loadWeather(currentWeather.location);
    }
  }

  Future<void> clearWeatherData() async {
    state = const AsyncValue.data(null);
    await _service.clearWeatherCache();
  }
}

final weatherViewModelProvider =
    StateNotifierProvider<WeatherViewModel, AsyncValue<WeatherModel?>>(
  (ref) =>
      WeatherViewModel(ref.watch(weatherRepositoryProvider), WeatherService()),
);
