import 'package:flutter_riverpod/flutter_riverpod.dart';

// StateNotifier per gestire lo stato della visibilità della barra di ricerca
class SearchBarVisibilityNotifier extends StateNotifier<bool> {
  SearchBarVisibilityNotifier() : super(false);

  void toggle() => state = !state;

  void show() => state = true;

  void hide() => state = false;
}

final searchBarVisibilityProvider =
    StateNotifierProvider<SearchBarVisibilityNotifier, bool>(
        (ref) => SearchBarVisibilityNotifier());
