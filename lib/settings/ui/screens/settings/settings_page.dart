import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meteo_app_esercizio_9/weather/di/favorite_cities_provider.dart';
import 'package:meteo_app_esercizio_9/weather/di/weather_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Impostazioni'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () async {
                await ref.read(weatherProvider.notifier).clearWeatherData();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Dati meteo eliminati')),
                );
              },
              child: const Text('Elimina dati meteo'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await ref.read(favoriteCitiesProvider.notifier).removeAll();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Città salvate eliminate')),
                );
              },
              child: const Text('Elimina città salvate'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await ref.read(weatherProvider.notifier).clearWeatherData();
                await ref.read(favoriteCitiesProvider.notifier).removeAll();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tutti i dati eliminati')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text(
                'Elimina tutti i dati',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
