import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteCityService {
  static const String _cacheFavoriteCities = 'cacheFavoriteCities';

  Future<void> setFavoriteCities(List<String> cities) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteCities = jsonEncode(cities);
    await prefs.setString(_cacheFavoriteCities, favoriteCities);
  }

  Future<List<String>> getFavoriteCities() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteCitiesData = prefs.getString(_cacheFavoriteCities);
    if (favoriteCitiesData != null) {
      return List<String>.from(jsonDecode(favoriteCitiesData));
    }
    return [];
  }

  Future<void> addFavoriteCity(String city) async {
    final cities = await getFavoriteCities();
    if (!cities.contains(city)) {
      cities.add(city);
      await setFavoriteCities(cities);
    }
  }

  Future<void> clearCitiesCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheFavoriteCities);
  }
}
