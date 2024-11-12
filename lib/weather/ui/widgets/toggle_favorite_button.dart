import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meteo_app_esercizio_9/Base/widgets/custom_snack_bar.dart';
import 'package:meteo_app_esercizio_9/weather/viewmodel/favorite_cities_viewmodel.dart';

class ToggleFavoriteButton extends ConsumerWidget {
  final String city;

  const ToggleFavoriteButton({
    super.key,
    required this.city,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteCitiesState = ref.watch(favoriteCitiesViewModelProvider);
    final favoriteCitiesNotifier =
        ref.read(favoriteCitiesViewModelProvider.notifier);

    final isFavorite = favoriteCitiesState.when(
      data: (cities) => cities.any((favoriteCity) => favoriteCity.name == city),
      loading: () => false,
      error: (error, _) => false,
    );

    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : Colors.grey,
        size: 32,
      ),
      onPressed: () {
        if (isFavorite) {
          favoriteCitiesNotifier.removeCity(city);
          CustomSnackBar.show(
            context,
            message: '$city rimossa dai preferiti',
            backgroundColor: Colors.red,
            icon: Icons.favorite_border,
          );
        } else {
          favoriteCitiesNotifier.addCity(city);
          CustomSnackBar.show(
            context,
            message: '$city aggiunta ai preferiti',
            backgroundColor: Colors.green,
            icon: Icons.favorite,
          );
        }
      },
    );
  }
}
