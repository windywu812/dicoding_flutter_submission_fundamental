// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/services/restaurant_api_services.dart';

void main() {
  group('Provider Test', () {
    ApiServices apiServices;

    setUp(() {
      apiServices = ApiServices();
    });

    group('Fetch List Tests', () {
      test('should able to call the api', () async {
        final response = await http.get(apiServices.baseURL);

        expectLater(response.statusCode, 200);
      });

      test('should able to return list', () async {
        final restaurants = await apiServices.fetchListRestaurant();

        expectLater(restaurants.length, 20);
      });
    });

    group('Fetch Search Test', () {
      test('should able to do some search', () async {
        final restaurant = await apiServices.fetchSearch('melting pot');

        expect(restaurant.first.name, 'Melting Pot');
      });
    });

    group('Fetch Detail Test', () {
      test('should able to fetch detail', () async {
        final detail = await apiServices.fetchDetail('rqdv5juczeskfw1e867');
        expect(detail.id, "rqdv5juczeskfw1e867");
      });
    });
  });
}
