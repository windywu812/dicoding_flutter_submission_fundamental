import 'package:restaurant_app/models/list_restaurants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiServices {
  final baseURL = 'https://restaurant-api.dicoding.dev/';

  Future<List<Restaurant>> fetchListRestaurant() async {
    final response = await http.get(baseURL + 'list');
    if (response.statusCode == 200) {
      final result = Response.fromJson(json.decode(response.body));
      return result.restaurants;
    } else {
      throw Exception(
          'Failed to load post with status code: ${response.statusCode}');
    }
  }
}
