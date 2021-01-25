class RestaurantResponse {
  List<Restaurant> restaurants;

  RestaurantResponse({this.restaurants});

  RestaurantResponse.fromJson(Map<String, dynamic> json) {
    restaurants = new List<Restaurant>();
    json['restaurants'].forEach((restaurant) {
      restaurants.add(new Restaurant.fromJson(restaurant));
    });
  }
}

class Restaurant {
  String id;
  String name;
  String description;
  String pictureId;
  String city;
  double rating;
  bool isFavorited;
  Menus menus;

  static String get tableName => 'restaurants';

  Restaurant({
    this.id,
    this.name,
    this.description,
    this.pictureId,
    this.city,
    this.rating,
    this.menus,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        pictureId: json["pictureId"],
        city: json["city"],
        rating: json["rating"].toDouble(),
        menus: Menus.fromJson(json["menus"]),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'pictureId': pictureId,
        'city': city,
        'rating': rating,
        'menus': menus.toMap(),
      };
}

class Menus {
  List<Food> foods;
  List<Food> drinks;

  Menus({
    this.foods,
    this.drinks,
  });

  factory Menus.fromJson(Map<String, dynamic> json) => Menus(
        foods: List<Food>.from(json["foods"].map((x) => Food.fromJson(x))),
        drinks: List<Food>.from(json["drinks"].map((x) => Food.fromJson(x))),
      );

  Map<String, dynamic> toMap() => {
        "foods": List<dynamic>.from(foods.map((x) => x.toMap())),
        "drinks": List<dynamic>.from(drinks.map((x) => x.toMap())),
      };
}

class Food {
  String name;

  Food({this.name});

  factory Food.fromJson(Map<String, dynamic> json) => Food(
        name: json['name'],
      );

  Map<String, dynamic> toMap() => {
        'name': name,
      };
}
