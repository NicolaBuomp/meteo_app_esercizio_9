import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meteo_app_esercizio_9/weather/ui/widgets/fovorite_city_list.dart';
import 'package:meteo_app_esercizio_9/weather/di/weather_provider.dart';
import '../widgets/weather_info.dart';

class WeatherContent extends ConsumerWidget {
  const WeatherContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(weatherProvider);

    return weatherState.when(
      data: (weather) => weather != null
          ? Column(
              children: [
                WeatherInfo(weather: weather),
                const SizedBox(height: 24),
                const FavoriteCityList(),
              ],
            )
          : const Center(
              child: Text(
                'Nessun dato disponibile',
                style: TextStyle(fontSize: 18),
              ),
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Text(
          'Errore: $err',
          style: const TextStyle(fontSize: 18, color: Colors.red),
        ),
      ),
    );
  }
}
