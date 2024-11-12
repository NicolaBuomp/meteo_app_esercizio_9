import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meteo_app_esercizio_9/weather/data/models/favorite_city_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoriteCitiesViewModel
    extends StateNotifier<AsyncValue<List<FavoriteCity>>> {
  static const String _cacheFavoriteCities = 'cacheFavoriteCities';

  FavoriteCitiesViewModel() : super(const AsyncValue.loading()) {
    _loadFavoriteCities();
  }

  Future<void> _loadFavoriteCities() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoriteCitiesData = prefs.getString(_cacheFavoriteCities);

      if (favoriteCitiesData != null) {
        final decodedData = jsonDecode(favoriteCitiesData);

        if (decodedData is List) {
          final favoriteCities = decodedData
              .map(
                  (city) => FavoriteCity.fromJson(city as Map<String, dynamic>))
              .toList();
          state = AsyncValue.data(favoriteCities);
        } else {
          state = const AsyncValue.data([]);
        }
      } else {
        state = const AsyncValue.data([]);
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> addCity(String cityName) async {
    final city = FavoriteCity(name: cityName);
    final currentState = state.value ?? [];

    if (!currentState.any((c) => c.name == cityName)) {
      final updatedList = [...currentState, city];
      state = AsyncValue.data(updatedList);
      await _saveFavoriteCities(updatedList);
    }
  }

  Future<void> removeCity(String cityName) async {
    final currentState = state.value ?? [];

    if (currentState.any((c) => c.name == cityName)) {
      final updatedList =
          currentState.where((c) => c.name != cityName).toList();
      state = AsyncValue.data(updatedList);
      await _saveFavoriteCities(updatedList);
    }
  }

  Future<void> removeAll() async {
    state = const AsyncValue.data([]);
    await _clearCitiesCache();
  }

  Future<void> _saveFavoriteCities(List<FavoriteCity> cities) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoriteCitiesJson =
          jsonEncode(cities.map((city) => city.toJson()).toList());
      await prefs.setString(_cacheFavoriteCities, favoriteCitiesJson);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> _clearCitiesCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cacheFavoriteCities);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final favoriteCitiesViewModelProvider = StateNotifierProvider<
    FavoriteCitiesViewModel, AsyncValue<List<FavoriteCity>>>((ref) {
  return FavoriteCitiesViewModel();
});
