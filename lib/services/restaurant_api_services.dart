import 'package:restaurant_app/models/detail_restaurant.dart';
import 'package:restaurant_app/models/list_restaurants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiServices {
  final baseURL = 'https://restaurant-api.dicoding.dev/';

  Future<List<Restaurant>> fetchListRestaurant() async {
    final response = await http.get(baseURL + 'list');
    if (response.statusCode == 200) {
      final result =
          AllRestaurantsResponse.fromJson(json.decode(response.body));
      return result.restaurants;
    } else {
      throw Exception(
          'Failed to load post with status code: ${response.statusCode}');
    }
  }

  Future<DetailRestaurant> fetchDetail(String id) async {
    final response = await http.get(baseURL + 'detail/$id');
    if (response.statusCode == 200) {
      final result = DetailResponse.fromJson(json.decode(response.body));
      return result.detail;
    } else {
      throw Exception(
          'Failed to load detail with status code: ${response.statusCode}');
    }
  }
}
