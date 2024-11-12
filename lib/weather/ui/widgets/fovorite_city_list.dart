import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meteo_app_esercizio_9/weather/ui/widgets/search_input.dart';
import 'package:meteo_app_esercizio_9/weather/viewmodel/favorite_cities_viewmodel.dart';
import '../../viewmodel/weather_viewmodel.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

class FavoriteCityList extends ConsumerWidget {
  const FavoriteCityList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteCitiesState = ref.watch(favoriteCitiesViewModelProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return favoriteCitiesState.when(
      data: (favoriteCities) {
        // Filtriamo le città preferite in base alla query di ricerca
        final filteredCities = favoriteCities.where((city) {
          return city.name.toLowerCase().contains(searchQuery.toLowerCase());
        }).toList();

        if (favoriteCities.isEmpty) {
          return const Text(
            'Aggiungi una città ai preferiti',
            style: TextStyle(fontSize: 18),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Città preferite',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  child: const Text('Svuota la lista'),
                  onPressed: () {
                    ref
                        .read(favoriteCitiesViewModelProvider.notifier)
                        .removeAll();
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            SearchInput(
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).state = value;
              },
            ),
            const SizedBox(height: 16),
            if (filteredCities.isEmpty)
              const Text(
                'Nessuna città trovata',
                style: TextStyle(fontSize: 16),
              )
            else
              SizedBox(
                height: 200,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredCities.length,
                  itemBuilder: (context, index) {
                    final city = filteredCities[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            city.name, // Usa il campo name del model
                            style: const TextStyle(fontSize: 18),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.search,
                                    color: Colors.grey),
                                onPressed: () {
                                  ref
                                      .read(weatherViewModelProvider.notifier)
                                      .loadWeather(city.name);
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  ref
                                      .read(favoriteCitiesViewModelProvider
                                          .notifier)
                                      .removeCity(city.name);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(
        child: Text(
          'Errore: $err',
          style: const TextStyle(fontSize: 18, color: Colors.red),
        ),
      ),
    );
  }
}
