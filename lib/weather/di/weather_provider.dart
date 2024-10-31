import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meteo_app_esercizio_9/weather/services/weather_service.dart';
import '../data/models/weather_model.dart';
import '../data/repository/weather_repository.dart';

class CityNotFoundException implements Exception {
  final String message;
  CityNotFoundException(this.message);

  @override
  String toString() => message;
}

class WeatherNotifier extends StateNotifier<AsyncValue<WeatherModel?>> {
  final WeatherRepository _repository;
  final WeatherService _weatherService;

  WeatherNotifier(this._repository, this._weatherService)
      : super(const AsyncValue.loading()) {
    loadWeather();
  }

  Future<void> loadWeather({String? city}) async {
    try {
      // Carica i dati meteo dalla cache locale se disponibili
      final cachedData = await _weatherService.getWeatherData();

      state = AsyncValue.data(cachedData);

      // Se viene fornito il nome della città, carica i dati dalla rete
      if (city != null && city.isNotEmpty) {
        state = const AsyncValue.loading();
        final weatherData = await _repository.fetchWeather(city);

        await _weatherService.saveWeatherData(weatherData);
        state = AsyncValue.data(weatherData);
      }
    } on CityNotFoundException catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> loadWeatherLatLong(double latitude, double longitude) async {
    try {
      state = const AsyncValue.loading();
      final weatherData =
          await _repository.fetchWeatherLatLong(latitude, longitude);

      await _weatherService.saveWeatherData(weatherData);
      state = AsyncValue.data(weatherData);
    } on CityNotFoundException catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> refreshWeather() async {
    try {
      // Una funzione per il refresh dei dati
      final cachedData = await _weatherService.getWeatherData();
      if (cachedData != null) {
        loadWeather(city: cachedData.location);
      }
    } on CityNotFoundException catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> clearWeatherData() async {
    state = const AsyncValue.data(null);
    await _weatherService.clearWeatherCache();
  }
}

final weatherProvider =
    StateNotifierProvider<WeatherNotifier, AsyncValue<WeatherModel?>>(
  (ref) => WeatherNotifier(WeatherRepository(), WeatherService()),
);
