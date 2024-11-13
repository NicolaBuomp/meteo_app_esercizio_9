import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meteo_app_esercizio_9/Base/service/theme_service.dart';

class ThemeViewModel extends StateNotifier<ThemeMode> {
  final ThemeService _themeService;

  ThemeViewModel(this._themeService) : super(ThemeMode.light) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final theme = await _themeService.loadTheme();
    state = theme;
  }

  void setLightMode() {
    state = ThemeMode.light;
    _themeService.saveTheme(ThemeMode.light);
  }

  void setDarkMode() {
    state = ThemeMode.dark;
    _themeService.saveTheme(ThemeMode.dark);
  }

  void setSystemMode() {
    state = ThemeMode.system;
    _themeService.saveTheme(ThemeMode.system);
  }

  void toggleTheme() {
    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
      _themeService.saveTheme(ThemeMode.dark);
    } else {
      state = ThemeMode.light;
      _themeService.saveTheme(ThemeMode.light);
    }
  }
}

final themeViewModelProvider =
    StateNotifierProvider<ThemeViewModel, ThemeMode>((ref) {
  final themeService = ThemeService();
  return ThemeViewModel(themeService);
});
