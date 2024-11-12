import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repository/weather_repository.dart';

final weatherRepositoryProvider = Provider((ref) => WeatherRepository());
