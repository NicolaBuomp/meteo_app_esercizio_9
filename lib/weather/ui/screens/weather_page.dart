import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meteo_app_esercizio_9/weather/ui/widgets/search_bar.dart';
import '../../viewmodel/weather_viewmodel.dart';
import '../widgets/weather_content.dart';
import '../widgets/weather_app_bar.dart';
import 'package:geolocator/geolocator.dart';

// StateProvider per gestire la visibilità della barra di ricerca
final searchBarVisibilityProvider = StateProvider<bool>((ref) => false);

class WeatherPage extends ConsumerWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(weatherViewModelProvider);
    final weatherViewModel = ref.read(weatherViewModelProvider.notifier);
    final searchController = TextEditingController();

    // Leggi lo stato di visibilità della barra di ricerca
    final showSearchField = ref.watch(searchBarVisibilityProvider);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: WeatherAppBar(
          showSearchField: showSearchField,
          onToggleSearchField: () {
            // Cambia lo stato di visibilità della barra di ricerca
            ref.read(searchBarVisibilityProvider.notifier).state =
                !showSearchField;
          },
          onLocationSearch: () async {
            final position = await Geolocator.getCurrentPosition();
            weatherViewModel.loadWeatherByLocation(
              position.latitude,
              position.longitude,
            );
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: weatherViewModel.refreshWeather,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (showSearchField)
                  SearchBarInput(
                    controller: searchController,
                    onSearch: () {
                      final city = searchController.text.trim();
                      if (city.isNotEmpty) {
                        weatherViewModel.loadWeather(city);
                      }
                    },
                  ),
                const SizedBox(height: 16),
                weatherState.when(
                  data: (weather) => WeatherContent(),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Text('Errore: $err'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
