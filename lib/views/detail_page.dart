import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/blocs/restaurant_bloc.dart';
import 'package:restaurant_app/components/shimmering_box.dart';
import 'package:restaurant_app/models/detail_restaurant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constant.dart' as Constant;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../repository/sqlite_db.dart';

class DetailPage extends StatefulWidget {
  static const routeName = '/detail_page';
  final String id;

  DetailPage({@required this.id});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool _isFavorited = false;
  SqliteDb _db;
  RestaurantBloc _bloc;

  @override
  void initState() {
    super.initState();

    _db = SqliteDb.shared;
    _db.open();
    _db.checkIfFavorited(widget.id).then((b) {
      setState(() {
        _isFavorited = b;
      });
    });

    _bloc = RestaurantBloc();
    _bloc.fetchDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _bloc.detailRestaurant,
        builder: (context, AsyncSnapshot<DetailRestaurant> snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.bottomStart,
                    children: [
                      Hero(
                        tag: snapshot.data.pictureId,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 8),
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 24,
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
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(24),
                              bottomRight: Radius.circular(24),
                            ),
                            child: CachedNetworkImage(
                              placeholder: (context, url) => Container(
                                color: Colors.grey,
                              ),
                              imageUrl: snapshot.data.pictureId,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 2.8,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${snapshot.data.name}',
                              style: Constant.largeTitleWhite,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: 34,
                                ),
                                Text(
                                  '${snapshot.data.city}',
                                  style: Constant.largeTitleWhite,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        left: 16,
                        top: 80,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 4),
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 24,
                                )
                              ],
                            ),
                            child: Icon(
                              Icons.arrow_back_ios_rounded,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Rating: ${snapshot.data.rating}',
                                  style: Constant.headline,
                                ),
                                RatingBarIndicator(
                                  rating: snapshot.data.rating,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star_rounded,
                                    color: Constant.primaryColor,
                                  ),
                                  itemCount: 5,
                                  itemSize: 25.0,
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Add to wishlist',
                                  style: Constant.headline,
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _db.insert(snapshot.data.id);
                                      this._isFavorited = !this._isFavorited;
                                    });
                                  },
                                  child: Icon(
                                    this._isFavorited
                                        ? Icons.favorite_rounded
                                        : Icons.favorite_border_rounded,
                                    color: Constant.primaryColor,
                                    size: 32,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text('About', style: Constant.headline),
                        Text(
                          snapshot.data.description,
                          style: Constant.bodyLabel,
                        ),
                        SizedBox(height: 16),
                        Text('Foods', style: Constant.headline),
                        buildFoodList('foods', snapshot),
                        SizedBox(height: 16),
                        Text('Drinks', style: Constant.headline),
                        buildFoodList('drinks', snapshot),
                        SizedBox(height: 44),
                      ],
                    ),
                  )
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Container buildFoodList(
      String type, AsyncSnapshot<DetailRestaurant> snapshot) {
    return Container(
      height: 40,
      child: ListView.builder(
        padding: EdgeInsets.only(top: 4),
        physics: ScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: snapshot.data.menus.foods.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.only(right: 16),
            padding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Constant.primaryColor),
            ),
            child: Text(
              type == 'foods'
                  ? '${snapshot.data.menus.foods[index].name}'
                  : '${snapshot.data.menus.drinks[index].name}',
              style: Constant.bodyPrimary,
            ),
          );
        },
      ),
    );
  }
}
