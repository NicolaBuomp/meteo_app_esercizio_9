import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meteo_app_esercizio_9/Base/di/theme_provider.dart';
import 'package:meteo_app_esercizio_9/weather/di/favorite_cities_provider.dart';
import 'package:meteo_app_esercizio_9/weather/viewmodel/weather_viewmodel.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final themeNotifier = ref.read(themeModeProvider.notifier);
    final weatherViewModel = ref.read(weatherViewModelProvider.notifier);

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
                await weatherViewModel.clearWeatherData();
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
                await weatherViewModel.clearWeatherData();
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
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Tema dell\'app',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            RadioListTile<ThemeMode>(
              title: const Text('Chiaro'),
              value: ThemeMode.light,
              groupValue: themeMode,
              onChanged: (value) {
                if (value != null) {
                  themeNotifier.state = value;
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Scuro'),
              value: ThemeMode.dark,
              groupValue: themeMode,
              onChanged: (value) {
                if (value != null) {
                  themeNotifier.state = value;
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Automatico'),
              value: ThemeMode.system,
              groupValue: themeMode,
              onChanged: (value) {
                if (value != null) {
                  themeNotifier.state = value;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
