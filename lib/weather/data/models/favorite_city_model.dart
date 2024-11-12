class FavoriteCity {
  final String name;

  FavoriteCity({required this.name});

  factory FavoriteCity.fromJson(Map<String, dynamic> json) {
    return FavoriteCity(
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}

class FavoriteCityList {
  final List<FavoriteCity> cities;

  FavoriteCityList({required this.cities});

  factory FavoriteCityList.fromJson(List<dynamic> json) {
    return FavoriteCityList(
      cities: json
          .map((e) => FavoriteCity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  List<Map<String, dynamic>> toJson() {
    return cities.map((city) => city.toJson()).toList();
  }
}
