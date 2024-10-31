import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider per gestire il tema dell'app
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
