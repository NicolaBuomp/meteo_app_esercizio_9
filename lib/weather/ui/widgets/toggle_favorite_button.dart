import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../di/favorite_cities_provider.dart';

class ToggleFavoriteButton extends ConsumerWidget {
  final String city;

  const ToggleFavoriteButton({
    super.key,
    required this.city,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteCitiesNotifier = ref.read(favoriteCitiesProvider.notifier);
    final favoriteCities = ref.watch(favoriteCitiesProvider);
    final isFavorite = favoriteCities.contains(city);

    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : Colors.grey,
          size: 32
      ),
      onPressed: () {
        if (isFavorite) {
          favoriteCitiesNotifier.removeCity(city);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$city rimossa dai preferiti'),
            ),
          );
        } else {
          favoriteCitiesNotifier.addCity(city);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$city aggiunta ai preferiti'),
            ),
          );
        }
      },
    );
  }
}
