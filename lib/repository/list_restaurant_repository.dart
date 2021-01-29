import 'package:restaurant_app/models/list_restaurants.dart';
import '../services/restaurant_api_services.dart';

class ListRestaurantRepository {
  final apiServices = ApiServices();

  Future<List<Restaurant>> fetchAllRestaurant() =>
      apiServices.fetchListRestaurant();
}
