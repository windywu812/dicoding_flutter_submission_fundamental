import 'package:restaurant_app/models/list_restaurants.dart';
import 'package:restaurant_app/repository/list_restaurant_repository.dart';
import 'package:rxdart/rxdart.dart';

class ListRestaurantBloc {
  final repository = ListRestaurantRepository();
  final popularRestaurantFetcher = PublishSubject<List<Restaurant>>();
  final allRestaurantFetcher = PublishSubject<List<Restaurant>>();

  Stream<List<Restaurant>> get popularRestaurant =>
      popularRestaurantFetcher.stream;
  Stream<List<Restaurant>> get allRestaurant => allRestaurantFetcher.stream;

  fetchAllRestaurant() async {
    List<Restaurant> restaurants = await repository.fetchAllRestaurant();
    List<Restaurant> popular = List();
    List<Restaurant> all = List();

    restaurants.forEach((r) {
      if (r.rating > 4.4) {
        popular.add(r);
      } else {
        all.add(r);
      }
    });

    popularRestaurantFetcher.sink.add(popular);
    allRestaurantFetcher.sink.add(all);
  }

  dispose() {
    allRestaurantFetcher.close();
  }
}
