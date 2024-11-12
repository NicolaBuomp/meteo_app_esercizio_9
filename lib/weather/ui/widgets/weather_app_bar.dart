import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meteo_app_esercizio_9/weather/ui/widgets/toggle_favorite_button.dart';
import 'package:meteo_app_esercizio_9/weather/viewmodel/weather_viewmodel.dart';

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
        final weatherState = ref.watch(weatherViewModelProvider);

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
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Weather App'),
                      LocationAndSearchToggle(
                        onLocationSearch: onLocationSearch,
                        onToggleSearchField: onToggleSearchField,
                      ),
                    ],
                  ),
            loading: () => null,
            error: (err, stack) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Weather App'),
                LocationAndSearchToggle(
                  onLocationSearch: onLocationSearch,
                  onToggleSearchField: onToggleSearchField,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class LocationAndSearchToggle extends StatelessWidget {
  const LocationAndSearchToggle({
    super.key,
    required this.onLocationSearch,
    required this.onToggleSearchField,
  });

  final VoidCallback onLocationSearch;
  final VoidCallback onToggleSearchField;

  @override
  Widget build(BuildContext context) {
    return Row(
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
      ],
    );
  }
}
