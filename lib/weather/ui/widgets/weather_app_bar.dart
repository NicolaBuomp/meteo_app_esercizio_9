import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meteo_app_esercizio_9/weather/ui/widgets/toggle_favorite_button.dart';
import 'package:meteo_app_esercizio_9/weather/di/weather_provider.dart';
import 'package:geolocator/geolocator.dart';

class WeatherAppBar extends StatelessWidget {
  final bool showSearchField;
  final VoidCallback onToggleSearchField;
  final VoidCallback onLocationSearch;

  const WeatherAppBar({
    super.key,
    required this.showSearchField,
    required this.onToggleSearchField,
    required this.onLocationSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final weatherState = ref.watch(weatherProvider);

        return AppBar(
          title: weatherState.when(
            data: (weather) => weather != null
                ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  weather.location,
                  style: const TextStyle(fontSize: 26),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: onLocationSearch,
                      icon: const Icon(
                        Icons.location_on,
                        size: 32,
                      ),
                    ),
                    IconButton(
                      onPressed: onToggleSearchField,
                      icon: const Icon(
                        Icons.search,
                        size: 32,
                      ),
                    ),
                    ToggleFavoriteButton(city: weather.location),
                  ],
                ),
              ],
            )
                : const Text('Weather App'),
            loading: () => const Text('Weather App'),
            error: (err, stack) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Weather App'),
                IconButton(
                  onPressed: onToggleSearchField,
                  icon: const Icon(
                    Icons.search,
                    size: 32,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}