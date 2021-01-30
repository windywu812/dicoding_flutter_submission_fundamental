import 'package:restaurant_app/models/detail_restaurant.dart';
import 'package:restaurant_app/models/list_restaurants.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/models/search_restaurant.dart';
import '../models/restaurant.dart';
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

  Future<List<Restaurant>> fetchSearch(String keyword) async {
    dynamic response;
    if (keyword == "") {
      response = await http.get(baseURL + 'list');
    } else {
      response = await http.get(baseURL + 'search?q=$keyword');
    }
    if (response.statusCode == 200) {
      final result = SearchResponse.fromJson(json.decode(response.body));
      return result.restaurants;
    } else {
      throw Exception(
          'Failed to load post with status code: ${response.statusCode}');
    }
  }

  Future<http.Response> postReview(
      String id, String name, String review) async {
    return await http.post(
      baseURL + 'review',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'X-Auth-Token': '12345',
      },
      body: jsonEncode(<String, String>{
        'id': id,
        'name': name,
        'review': review,
      }),
    );
  }
}
