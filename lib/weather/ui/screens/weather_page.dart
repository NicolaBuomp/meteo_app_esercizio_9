import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meteo_app_esercizio_9/weather/di/search_bar_visibility_provider.dart';
import 'package:meteo_app_esercizio_9/weather/ui/widgets/search_bar.dart';
import '../../viewmodel/weather_viewmodel.dart';
import '../widgets/weather_content.dart';
import '../widgets/weather_app_bar.dart';

class WeatherPage extends ConsumerWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(weatherViewModelProvider);
    final weatherViewModel = ref.read(weatherViewModelProvider.notifier);
    final showSearchField = ref.watch(searchBarVisibilityProvider);
    final searchController = TextEditingController();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: WeatherAppBar(
          showSearchField: showSearchField,
          onToggleSearchField: () {
            ref.read(searchBarVisibilityProvider.notifier).toggle();
          },
          onLocationSearch: () async {
            try {
              await weatherViewModel.loadWeatherWithPermission();
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Errore: $e')),
              );
            }
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
                        ref.read(searchBarVisibilityProvider.notifier).hide();
                        searchController.clear();
                      }
                    },
                  ),
                const SizedBox(height: 16),
                weatherState.when(
                  data: (weather) => WeatherContent(),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (err, _) => Center(
                    child: Text(
                      'Errore: $err',
                      style: const TextStyle(fontSize: 18, color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
