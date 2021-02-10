import 'package:restaurant_app/models/restaurant.dart';
import 'package:restaurant_app/services/local_services.dart';

class FavoriteRepository {
  final localServices = LocalServices();

  Future<List<Restaurant>> fetchFavorites() => localServices.getFavoriteList();
}
