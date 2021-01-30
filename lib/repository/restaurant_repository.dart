import 'package:restaurant_app/models/detail_restaurant.dart';
import '../models/restaurant.dart';
import '../services/restaurant_api_services.dart';

class RestaurantRepository {
  final apiServices = ApiServices();

  Future<List<Restaurant>> fetchAllRestaurant() =>
      apiServices.fetchListRestaurant();

  Future<DetailRestaurant> fetchDetail(String id) =>
      apiServices.fetchDetail(id);

  Future<List<Restaurant>> fetchSearch(String keyword) =>
      apiServices.fetchSearch(keyword);
}
