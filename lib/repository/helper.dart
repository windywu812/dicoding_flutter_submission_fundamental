import 'dart:convert';
import 'package:restaurant_app/models/restaurant.dart';

class Helper {
  static List<Restaurant> parseRestaurant(String json) {
    if (json == null) {
      return [];
    }

    return RestaurantResponse.fromJson(jsonDecode(json)).restaurants;
  }
}
