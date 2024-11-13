import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meteo_app_esercizio_9/weather/data/models/favorite_city_model.dart';
import 'package:meteo_app_esercizio_9/weather/di/weather_provider.dart';

class FavoriteCityCard extends ConsumerWidget {
  final FavoriteCity city;
  final VoidCallback onTap;

  const FavoriteCityCard({
    super.key,
    required this.city,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(weatherRepositoryProvider(city.name));

    return GestureDetector(
      onTap: onTap, // Azione da eseguire quando la card viene cliccata
      child: Container(
        width: 250,
        height: 150,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xFF6631BD),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: weatherState.when(
          data: (weather) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  const Icon(Icons.cloud, size: 32, color: Colors.white),
                  const SizedBox(width: 20),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Location',
                          style: TextStyle(color: Colors.white70),
                        ),
                        Text(
                          city.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow
                              .ellipsis, // Troncamento del testo lungo
                          maxLines: 1, // Limita a una riga
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _WeatherDetail(label: 'Wind', value: '${weather.windSpeed}'),
                  _WeatherDetail(
                      label: 'Temp', value: '${weather.temperature}°C'),
                  _WeatherDetail(
                      label: 'Humidity', value: '${weather.humidity}%'),
                ],
              ),
            ],
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
          error: (err, _) => const Text(
            'Errore',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}

class _WeatherDetail extends StatelessWidget {
  final String label;
  final String value;

  const _WeatherDetail({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18)),
      ],
    );
  }
}
