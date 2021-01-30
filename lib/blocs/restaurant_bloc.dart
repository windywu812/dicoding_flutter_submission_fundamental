import 'package:restaurant_app/models/detail_restaurant.dart';
import 'package:restaurant_app/models/list_restaurants.dart';
import 'package:restaurant_app/repository/restaurant_repository.dart';
import 'package:rxdart/rxdart.dart';

class RestaurantBloc {
  final repository = RestaurantRepository();

  final popularRestaurantFetcher = PublishSubject<List<Restaurant>>();
  final allRestaurantFetcher = PublishSubject<List<Restaurant>>();
  final detailRestaurantFetcher = PublishSubject<DetailRestaurant>();

  Stream<List<Restaurant>> get popularRestaurant =>
      popularRestaurantFetcher.stream;
  Stream<List<Restaurant>> get allRestaurant => allRestaurantFetcher.stream;
  Stream<DetailRestaurant> get detailRestaurant =>
      detailRestaurantFetcher.stream;

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

  fetchDetail(String id) async {
    DetailRestaurant detail = await repository.fetchDetail(id);
    detailRestaurantFetcher.sink.add(detail);
  }

  dispose() {
    allRestaurantFetcher.close();
    popularRestaurantFetcher.close();
    detailRestaurantFetcher.close();
  }
}
