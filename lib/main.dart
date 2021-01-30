import 'package:flutter/material.dart';
import 'package:restaurant_app/views/about_me_page.dart';
import 'package:restaurant_app/views/detail_page.dart';
import 'package:restaurant_app/views/home_page.dart';
import 'package:restaurant_app/views/search_page.dart';
import 'constant.dart' as Constant;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
