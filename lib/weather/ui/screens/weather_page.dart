import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meteo_app_esercizio_9/weather/ui/widgets/favorite_city.dart';
import 'package:meteo_app_esercizio_9/weather/ui/widgets/fovorite_city_list.dart';
import 'package:meteo_app_esercizio_9/weather/ui/widgets/search.dart';
import 'package:meteo_app_esercizio_9/weather/di/weather_provider.dart';
import '../widgets/weather_info.dart';

class WeatherPage extends ConsumerStatefulWidget {
  const WeatherPage({super.key});

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends ConsumerState<WeatherPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _showSearchField = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchWeather() {
    final city = _searchController.text.trim();
    if (city.isNotEmpty) {
      ref.read(weatherProvider.notifier).loadWeather(city: city);
    }
    _searchController.text = '';

    FocusScope.of(context).unfocus();
  }

  void _toggleSearchField() {
    setState(() {
      _showSearchField = !_showSearchField;
      if (!_showSearchField) {
        _searchController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final weatherState = ref.watch(weatherProvider);

    return Scaffold(
      appBar: AppBar(
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
                          onPressed: _toggleSearchField,
                          icon: const Icon(
                            Icons.search,
                            size: 32,
                          ),
                        ),
                        FavoriteButton(city: weather.location),
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
                onPressed: _toggleSearchField,
                icon: const Icon(
                  Icons.search,
                  size: 32,
                ),
              ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SizeTransition(
                      sizeFactor: animation,
                      axisAlignment: -1.0,
                      child: child,
                    ),
                  );
                },
                child: _showSearchField
                    ? Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          key: const ValueKey<bool>(true),
                          children: [
                            Expanded(
                              child: SearchInput(controller: _searchController),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 12.0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              onPressed: _searchWeather,
                              child: const Text(
                                'Cerca',
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 24),
              weatherState.when(
                data: (weather) => weather != null
                    ? Column(
                        children: [
                          WeatherInfo(weather: weather),
                          const SizedBox(height: 24),
                          const FavoriteCityList()
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
