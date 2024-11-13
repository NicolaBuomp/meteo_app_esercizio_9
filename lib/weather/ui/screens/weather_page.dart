import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meteo_app_esercizio_9/weather/ui/widgets/search_input.dart';
import '../../viewmodel/weather_viewmodel.dart';
import '../widgets/weather_content.dart';

class WeatherPage extends ConsumerWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(weatherViewModelProvider);
    final weatherViewModel = ref.read(weatherViewModelProvider.notifier);
    final searchController = TextEditingController();

    // Determina il testo del placeholder dinamico
    String hintText = "Cerca";
    weatherState.whenData((weather) {
      if (weather != null) {
        hintText = '${weather.location}, ${weather.region}, ${weather.country}';
      }
    });

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: RefreshIndicator(
          onRefresh: weatherViewModel.refreshWeather,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CustomSearchInput(
                  controller: searchController,
                  hintText: hintText, // Usa il nome della città o "Cerca"
                  leadingIcon: Icons.location_on_rounded,
                  trailingIcon: Icons.send_rounded,
                  onLeadingIconTap: () async {
                    try {
                      await weatherViewModel.loadWeatherWithPermission();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Errore: $e')),
                      );
                    }
                  },
                  onTrailingIconTap: () {
                    final city = searchController.text.trim();
                    if (city.isNotEmpty) {
                      weatherViewModel.loadWeather(city);
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
