import 'package:restaurant_app/models/detail_restaurant.dart';
import 'package:restaurant_app/models/list_restaurants.dart';
import '../services/restaurant_api_services.dart';

class RestaurantRepository {
  final apiServices = ApiServices();

  Future<List<Restaurant>> fetchAllRestaurant() =>
      apiServices.fetchListRestaurant();

  Future<DetailRestaurant> fetchDetail(String id) =>
      apiServices.fetchDetail(id);
}
