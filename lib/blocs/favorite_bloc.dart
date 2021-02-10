import 'package:restaurant_app/repository/favorite_repository.dart';
import '../models/restaurant.dart';
import 'package:rxdart/rxdart.dart';

class FavoriteBloc {
  final repository = FavoriteRepository();
  final favoriteFetcher = PublishSubject<List<Restaurant>>();

  Stream<List<Restaurant>> get favoriteRestaurants => favoriteFetcher.stream;

  fetchAllRestaurant() async {
    List<Restaurant> restaurants = await repository.fetchFavorites();

    favoriteFetcher.sink.add(restaurants);
  }

  dispose() {
    favoriteFetcher.close();
  }
}
