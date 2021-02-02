import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/blocs/restaurant_bloc.dart';
import 'package:restaurant_app/components/custom_textfield.dart';
import 'package:restaurant_app/components/shimmering_box.dart';
import '../models/restaurant.dart';
import 'package:restaurant_app/views/detail_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:restaurant_app/views/search_page.dart';
import '../constant.dart' as Constant;
import 'about_me_page.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home_page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RestaurantBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = RestaurantBloc();
    bloc.fetchAllRestaurant();
  }

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
              padding: EdgeInsets.only(left: 16, bottom: 16),
              child: Text(
                'Popular',
                style: Constant.title1,
              ),
            ),
            StreamBuilder(
              stream: bloc.popularRestaurant,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Restaurant>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.isNotEmpty) {
                    return Container(
                      height: 140,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: ScrollPhysics(),
                        itemCount: snapshot.data.length,
                        clipBehavior: Clip.none,
                        itemBuilder: (context, index) {
                          return buildPopularRestaurant(
                              context, snapshot.data[index]);
                        },
                      ),
                    );
                  } else {
                    return Center(
                      child: Text(
                        "No Internet Connection",
                        style: Constant.bodyLabel,
                      ),
                    );
                  }
                } else {
                  return Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: ShimmeringBox(),
                  );
                }
              },
            ),
            SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.only(left: 16, bottom: 16),
              child: Text(
                'Others Recommend',
                style: Constant.title1,
              ),
            ),
            StreamBuilder(
              stream: bloc.allRestaurant,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Restaurant>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.isNotEmpty) {
                    return ListView.builder(
                      padding: EdgeInsets.only(bottom: 48),
                      scrollDirection: Axis.vertical,
                      physics: ScrollPhysics(),
                      itemCount: snapshot.data.length,
                      clipBehavior: Clip.none,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return buildRestaurantCell(
                            context, snapshot.data[index]);
                      },
                    );
                  } else {
                    return Center(
                      child: Text(
                        "No Internet Connection",
                        style: Constant.bodyLabel,
                      ),
                    );
                  }
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

  Widget buildPopularRestaurant(BuildContext context, Restaurant restaurant) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, DetailPage.routeName,
            arguments: restaurant.id);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Stack(
          children: [
            Hero(
              tag: restaurant.pictureId,
              child: Container(
                width: 200,
                height: 140,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 24,
                      offset: Offset(-10, 16),
                      color: Colors.black.withOpacity(0.1),
                    )
                  ],
                ),
                foregroundDecoration: BoxDecoration(
                  gradient: new LinearGradient(
                    end: const Alignment(0.0, -1),
                    begin: const Alignment(0.0, 0.6),
                    colors: <Color>[
                      Colors.black.withOpacity(0.6),
                      Colors.black.withOpacity(0.0)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      color: Colors.grey,
                    ),
                    imageUrl: restaurant.pictureId,
                    width: 200,
                    height: 140,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 8,
              bottom: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: Constant.bodyWhite,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      Text(
                        restaurant.city,
                        style: Constant.bodyWhite,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRestaurantCell(BuildContext context, Restaurant restaurant) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, DetailPage.routeName,
            arguments: restaurant.id);
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
      height: 240,
      child: Column(
        children: [
          SizedBox(height: 80),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Find your \nrestaurant',
                  style: Constant.largeTitle,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AboutMePage.routeName,
                    );
                  },
                  child: Hero(
                    tag: 'profile-pic',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(52 / 2),
                      child: Image.asset(
                        'assets/me-pic.jpg',
                        width: 52,
                        height: 52,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomTextfield(
              onTapFunction: () {
                Navigator.pushNamed(context, SearchPage.routeName);
              },
            ),
          ),
        ],
      ),
    );
  }
}
