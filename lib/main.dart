import 'package:flutter/material.dart';
import 'package:restaurant_app/services/notification_services.dart';
import 'package:restaurant_app/views/about_me_page.dart';
import 'package:restaurant_app/views/detail_page.dart';
import 'package:restaurant_app/views/home_page.dart';
import 'package:restaurant_app/views/search_page.dart';
import 'constant.dart' as Constant;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationServices.shared
      .initNotifications(flutterLocalNotificationsPlugin);
  NotificationServices.shared
      .requestIOSPermissions(flutterLocalNotificationsPlugin);

  final _pref = await SharedPreferences.getInstance();

  if (_pref.getBool('NotificationKey') == null) {
    _pref.setBool('NotificationKey', false);
  }

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant App',
      theme: ThemeData(accentColor: Constant.primaryColor),
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (context) => HomePage(),
        DetailPage.routeName: (context) => DetailPage(
              id: ModalRoute.of(context).settings.arguments,
            ),
        AboutMePage.routeName: (context) => AboutMePage(),
        SearchPage.routeName: (context) => SearchPage(),
      },
    ),
  );
}
