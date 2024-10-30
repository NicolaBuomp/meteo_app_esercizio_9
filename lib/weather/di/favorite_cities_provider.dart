import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoriteCitiesNotifier extends StateNotifier<List<String>> {
  FavoriteCitiesNotifier() : super([]) {
    _loadFavoriteCities();
  }

  static const String _cacheFavoriteCities = 'cacheFavoriteCities';

  Future<void> _loadFavoriteCities() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteCitiesData = prefs.getString(_cacheFavoriteCities);
    if (favoriteCitiesData != null) {
      state = List<String>.from(jsonDecode(favoriteCitiesData));
    }
  }

  Future<void> addCity(String city) async {
    if (!state.contains(city)) {
      final updatedList = [...state, city];
      state = updatedList;
      await _saveFavoriteCities(updatedList);
    }
  }

  Future<void> removeCity(String city) async {
    if (state.contains(city)) {
      final updatedList = state.where((c) => c != city).toList();
      state = updatedList;
      await _saveFavoriteCities(updatedList);
    }
  }

  Future<void> _saveFavoriteCities(List<String> cities) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteCities = jsonEncode(cities);
    await prefs.setString(_cacheFavoriteCities, favoriteCities);
  }
}

final favoriteCitiesProvider =
StateNotifierProvider<FavoriteCitiesNotifier, List<String>>((ref) {
  return FavoriteCitiesNotifier();
});
