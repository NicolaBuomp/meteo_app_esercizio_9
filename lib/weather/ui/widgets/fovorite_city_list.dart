import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meteo_app_esercizio_9/weather/ui/widgets/favorite_city_card.dart';
import 'package:meteo_app_esercizio_9/weather/viewmodel/favorite_cities_viewmodel.dart';

class FavoriteCityList extends ConsumerWidget {
  const FavoriteCityList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteCitiesState = ref.watch(favoriteCitiesViewModelProvider);

    return favoriteCitiesState.when(
      data: (cities) {
        if (cities.isEmpty) {
          return const Center(
            child: Text(
              'No favorite cities',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: cities.map((city) {
              return FavoriteCityCard(
                city: city,
                onTap: () {},
              );
            }).toList(),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Text(
          'Error: $error',
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
