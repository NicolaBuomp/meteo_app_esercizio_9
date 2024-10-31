import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meteo_app_esercizio_9/weather/data/models/weather_model.dart';

import '../../services/weather_service.dart';

class WeatherInfo extends StatelessWidget {
  final WeatherModel weather;

  const WeatherInfo({super.key, required this.weather});

  String _formatDate(String date) {
    try {
      final parsedDate = DateFormat("yyyy-MM-dd HH:mm").parse(date);
      return DateFormat("dd MMMM yyyy, HH:mm").format(parsedDate);
    } catch (e) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weather.location,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      weather.region,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      weather.country,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Image.network(
                  height: 80,
                  width: 80,
                  weather.iconUrl,
                  fit: BoxFit.contain,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '${weather.temperature}°C - ${weather.condition}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 8),
            Text(
              'Ultimo aggiornamento: ${_formatDate(weather.localtime)}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text('Umidità: ${weather.humidity}%'),
            Text('Vento: ${weather.windSpeed} km/h'),
          ],
        ),
      ),
    );
  }
}
