import 'restaurant.dart';

class AllRestaurantsResponse {
  AllRestaurantsResponse({
    this.error,
    this.message,
    this.count,
    this.restaurants,
  });

  bool error;
  String message;
  int count;
  List<Restaurant> restaurants;

  factory AllRestaurantsResponse.fromJson(Map<String, dynamic> json) =>
      AllRestaurantsResponse(
        error: json["error"],
        message: json["message"],
        count: json["count"],
        restaurants: List<Restaurant>.from(
            json["restaurants"].map((x) => Restaurant.fromJson(x))),
      );
}
