import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:restaurant_app/models/detail_restaurant.dart';
import 'package:restaurant_app/models/restaurant.dart';
import 'package:restaurant_app/services/restaurant_api_services.dart';
import 'package:sqflite/sqflite.dart';

class SqliteDb {
  static final shared = SqliteDb();

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
          city TEXT,
          pictureId TEXT,
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
        db.delete(Restaurant.tableName,
            where: 'id = ?', whereArgs: [restaurant.id]);
      }
    });
  }

  Future<List<Map>> getAll() async {
    List<Map<String, dynamic>> restaurants =
        await db.query(Restaurant.tableName);
    return restaurants;
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

  Future<List<Restaurant>> getFavoriteList(BuildContext context) async {
    open();

    List<Restaurant> filter = List<Restaurant>();

    final List<Restaurant> restaurants =
        await ApiServices().fetchListRestaurant();

    restaurants.forEach((r) {
      checkIfFavorited(r.id).then((bool) {
        if (bool) {
          filter.add(r);
        }
      });
    });

    return filter;
  }
}
