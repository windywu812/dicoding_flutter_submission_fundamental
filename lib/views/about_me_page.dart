import 'package:flutter/material.dart';
import 'package:restaurant_app/components/shimmering_box.dart';
import 'package:restaurant_app/models/restaurant.dart';
import '../constant.dart' as Constant;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../repository/sqlite_db.dart';
import 'detail_page.dart';

class AboutMePage extends StatefulWidget {
  static const routeName = '/about_me_page';

  @override
  _AboutMePageState createState() => _AboutMePageState();
}

class _AboutMePageState extends State<AboutMePage> {
  final db = SqliteDb.shared;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTopView(context),
            SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Wishlist',
                style: Constant.title1,
              ),
            ),
            FutureBuilder(
              future: db.getFavoriteList(context),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    padding: EdgeInsets.only(top: 16, bottom: 48),
                    scrollDirection: Axis.vertical,
                    physics: ScrollPhysics(),
                    itemCount: snapshot.data.length,
                    clipBehavior: Clip.none,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return buildRestaurantCell(context, snapshot.data[index]);
                    },
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: ShimmeringBox(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Container buildTopView(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
        color: Constant.primaryColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 30,
            color: Colors.black.withOpacity(0.1),
          )
        ],
      ),
      width: MediaQuery.of(context).size.width,
      height: 240,
      child: Column(
        children: [
          SizedBox(height: 80),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back_ios_rounded),
                    ),
                    Spacer(),
                    Text(
                      'About Me',
                      style: Constant.largeTitle,
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Hero(
                      tag: 'profile-pic',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.asset(
                          'assets/me-pic.jpg',
                          width: 80,
                          height: 80,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Windy',
                          style: Constant.title1,
                        ),
                        Text(
                          'Food Lovers',
                          style: TextStyle(
                            fontFamily: 'Futura',
                            fontSize: 20.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRestaurantCell(BuildContext context, Restaurant restaurant) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, DetailPage.routeName,
                arguments: restaurant.id)
            .then((value) => setState(() {}));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          height: 120,
          margin: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 24,
                offset: Offset(0, 8),
                color: Colors.black.withOpacity(0.1),
              )
            ],
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Hero(
                tag: restaurant.pictureId,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    topLeft: Radius.circular(8),
                  ),
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      color: Colors.grey,
                    ),
                    imageUrl: restaurant.pictureId,
                    width: MediaQuery.of(context).size.width / 2 - 32,
                    height: 120,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 48,
                      child: Text(
                        '${restaurant.name}',
                        style: Constant.bodyLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    RatingBarIndicator(
                      rating: restaurant.rating,
                      itemBuilder: (context, index) => Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 22.0,
                    ),
                    Text(
                      'Rating: ${restaurant.rating}',
                      style: Constant.secondaryLabel,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.black.withOpacity(0.5),
                        ),
                        Text(
                          restaurant.city,
                          style: Constant.secondaryLabel,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Constant.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
