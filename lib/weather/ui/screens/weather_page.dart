import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meteo_app_esercizio_9/weather/ui/widgets/search_bar.dart';
import 'package:meteo_app_esercizio_9/weather/ui/widgets/weather_app_bar.dart';
import 'package:meteo_app_esercizio_9/weather/ui/widgets/weather_content.dart';
import 'package:geolocator/geolocator.dart';

import '../../di/weather_provider.dart';

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
    _searchController.clear();
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

  Future<void> _searchWithPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return Future.error('I servizi di localizzazione sono disabilitati.');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.deniedForever) return Future.error('I permessi sono permanentemente negati');

    final position = await Geolocator.getCurrentPosition();
    ref.read(weatherProvider.notifier).loadWeatherLatLong(position.latitude, position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: WeatherAppBar(
          showSearchField: _showSearchField,
          onToggleSearchField: _toggleSearchField,
          onLocationSearch: _searchWithPosition,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.read(weatherProvider.notifier).refreshWeather(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (_showSearchField)
                  SearchBarInput(
                    controller: _searchController,
                    onSearch: _searchWeather,
                  ),
                const SizedBox(height: 24),
                const WeatherContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
