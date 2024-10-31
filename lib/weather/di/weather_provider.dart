import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/weather_model.dart';
import '../data/repository/weather_repository.dart';
import '../services/weather_service.dart';

class CityNotFoundException implements Exception {
  final String message;
  CityNotFoundException(this.message);

  @override
  String toString() => message;
}

class WeatherNotifier extends StateNotifier<AsyncValue<WeatherModel?>> {
  final WeatherRepository _repository;
  final WeatherService _service;

  WeatherNotifier(this._repository, this._service)
      : super(const AsyncValue.loading()) {
    loadWeather();
  }

  Future<void> loadWeather({String? city}) async {
    try {
      // Carica i dati meteo dalla cache locale se disponibili
      final cachedData = await _service.getWeatherData();
      if (cachedData != null) {
        state = AsyncValue.data(cachedData);
      } else if (city == null || city.isEmpty) {
        // Se non ci sono dati nella cache e nessuna città è stata fornita, mostra un messaggio di errore appropriato
        state = AsyncValue.error(
            'Nessun dato disponibile. Cerca una città per iniziare.',
            StackTrace.current);
        return;
      }

      // Se viene fornito il nome della città, carica i dati dalla rete
      if (city != null && city.isNotEmpty) {
        state = const AsyncValue
            .loading(); // Mostra un caricamento mentre vengono caricati i nuovi dati
        final weatherData = await _repository.fetchWeather(city);

        await _service.saveWeatherData(weatherData);
        state = AsyncValue.data(weatherData);
      }
    } on CityNotFoundException catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final weatherProvider =
    StateNotifierProvider<WeatherNotifier, AsyncValue<WeatherModel?>>(
  (ref) => WeatherNotifier(WeatherRepository(), WeatherService()),
);
