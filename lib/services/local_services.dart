import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:restaurant_app/models/detail_restaurant.dart';
import 'package:restaurant_app/models/restaurant.dart';
import 'package:sqflite/sqflite.dart';

class LocalServices {
  static final shared = LocalServices();

  static Database db;
  static String sqliteDbName = 'restaurants.db';

  Future open() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'restaurants.db';
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
        ''' 
        CREATE TABLE IF NOT EXISTS ${Restaurant.tableName} (
          id TEXT PRIMARY KEY,
          name TEXT,
          pictureId TEXT,
          city TEXT,
          rating TEXT
          )''',
      );
    });
  }

  Future insert(DetailRestaurant restaurant) async {
    await checkIfFavorited(restaurant.id).then((result) {
      if (!result) {
        db.insert(Restaurant.tableName, restaurant.toJson());
      } else {
        delete(restaurant.id);
      }
    });
  }

  void delete(String id) {
    db.delete(Restaurant.tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> checkIfFavorited(String id) async {
    List<Map<String, dynamic>> restaurants =
        await db.query(Restaurant.tableName);

    bool isFavorited = false;
    restaurants.forEach((r) {
      if (r['id'] == id) {
        isFavorited = true;
      }
    });

    return isFavorited;
  }

  Future<List<Restaurant>> getFavoriteList() async {
    if (db == null) {
      await open();
    }

    List<Restaurant> restaurants = List<Restaurant>();

    List<Map<String, dynamic>> restaurantsDb =
        await db.query(Restaurant.tableName);

    restaurantsDb.forEach((r) {
      restaurants.add(Restaurant(
        id: r['id'],
        name: r['name'],
        pictureId: r['pictureId'],
        city: r['city'],
        rating: double.parse(r['rating']),
      ));
    });

    return restaurants;
  }
}
