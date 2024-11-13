import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ThemeService {
  static const String _themeKey = 'selectedTheme';

  Future<void> saveTheme(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, jsonEncode(themeMode.toString()));
  }

  Future<ThemeMode> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(_themeKey);

    if (themeString != null) {
      if (themeString == ThemeMode.dark.toString()) {
        return ThemeMode.dark;
      } else {
        return ThemeMode.light;
      }
    } else {
      return ThemeMode.light;
    }
  }
}
