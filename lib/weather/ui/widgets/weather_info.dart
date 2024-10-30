import 'package:flutter/material.dart';
import 'package:meteo_app_esercizio_9/weather/data/models/weather_model.dart';
import 'package:meteo_app_esercizio_9/weather/ui/widgets/search.dart';

class WeatherInfo extends StatelessWidget {
  final WeatherModel weather;

  const WeatherInfo({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            weather.location,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Image.network(weather.iconUrl),
          const SizedBox(height: 16),
          Text(
            '${weather.temperature}°C - ${weather.condition}',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 8),
          Text('Ultimo aggiornamento: ${weather.localtime}'),
          const SizedBox(height: 8),
          Text('Umidità: ${weather.humidity}%'),
          Text('Vento: ${weather.windSpeed} km/h'),
        ],
      ),
    );
  }
}