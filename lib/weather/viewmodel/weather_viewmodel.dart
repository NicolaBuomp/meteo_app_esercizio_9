import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../data/models/weather_model.dart';
import '../data/repository/weather_repository.dart';

class WeatherViewModel extends StateNotifier<AsyncValue<WeatherModel?>> {
  final WeatherRepository _repository;

  WeatherViewModel(this._repository) : super(const AsyncValue.loading());

  Future<void> loadWeather(String city) async {
    try {
      state = const AsyncValue.loading();
      final weather = await _repository.getWeatherByCity(city);
      state = AsyncValue.data(weather);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> loadWeatherByLocation(double latitude, double longitude) async {
    try {
      state = const AsyncValue.loading();
      final weather =
          await _repository.getWeatherByCoordinates(latitude, longitude);
      state = AsyncValue.data(weather);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> refreshWeather() async {
    if (state.value != null) {
      final weather = state.value!;
      await loadWeather(weather.location);
    }
  }

  Future<void> loadWeatherWithPermission() async {
    try {
      final position = await _determinePosition();
      await loadWeatherByLocation(position.latitude, position.longitude);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception(
          'I servizi di localizzazione sono disabilitati. Abilitali nelle impostazioni.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permesso di localizzazione negato.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Permesso negato permanentemente. Abilitalo nelle impostazioni.');
    }

    return await Geolocator.getCurrentPosition();
  }

  /// Metodo per cancellare i dati meteo
  Future<void> clearWeatherData() async {
    state = const AsyncValue.data(null);
  }
}

final weatherViewModelProvider =
    StateNotifierProvider<WeatherViewModel, AsyncValue<WeatherModel?>>((ref) {
  final repository = WeatherRepository();
  return WeatherViewModel(repository);
});
