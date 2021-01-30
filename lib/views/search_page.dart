import 'package:flutter/material.dart';
import 'package:restaurant_app/blocs/restaurant_bloc.dart';
import 'package:restaurant_app/components/shimmering_box.dart';
import 'package:restaurant_app/models/restaurant.dart';
import '../models/restaurant.dart';
import 'package:restaurant_app/views/detail_page.dart';
import '../constant.dart' as Constant;
import '../components/custom_textfield.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../views/detail_page.dart';

class SearchPage extends StatefulWidget {
  static const routeName = '/search_page';

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  RestaurantBloc _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = RestaurantBloc();
    _bloc.fetchSearch("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildTopView(context),
          Expanded(
            child: StreamBuilder(
              stream: _bloc.searchRestaurant,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Restaurant>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GridView.builder(
                        padding: EdgeInsets.only(top: 16, bottom: 64),
                        itemCount: snapshot.data.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio:
                              (MediaQuery.of(context).size.width - 48) / 460,
                        ),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                DetailPage.routeName,
                                arguments: snapshot.data[index].id,
                              );
                            },
                            child: buildGridCell(snapshot.data, index, context),
                          );
                        },
                      ),
                    );
                  } else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Not found',
                            style: Constant.title1,
                          ),
                          Text(
                            'Please Enter different keyword',
                            style: Constant.bodyLabel,
                          ),
                        ],
                      ),
                    );
                  }
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ShimmeringBox(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Container buildGridCell(
      List<Restaurant> filter, int index, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, 4),
            blurRadius: 15,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: filter[index].pictureId,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8),
                topLeft: Radius.circular(8),
              ),
              child: CachedNetworkImage(
                placeholder: (context, url) => Container(
                  color: Colors.grey,
                ),
                imageUrl: filter[index].pictureId,
                height: 115,
                width: MediaQuery.of(context).size.width - 48,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  filter[index].name,
                  style: Constant.bodyLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                RatingBarIndicator(
                  rating: filter[index].rating,
                  itemBuilder: (context, index) => Icon(
                    Icons.star_rounded,
                    color: Colors.amber,
                  ),
                  itemCount: 5,
                  itemSize: 22.0,
                ),
                Text(
                  'Rating: ${filter[index].rating}',
                  style: Constant.secondaryLabel,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.black.withOpacity(0.5),
                    ),
                    Text(
                      filter[index].city,
                      style: Constant.secondaryLabel,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _buildTopView(BuildContext context) {
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
      height: 200,
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
                      'Search',
                      style: Constant.largeTitle,
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(height: 16),
                CustomTextfield(
                  onChangedFunction: (keyword) {
                    setState(() {
                      _bloc.fetchSearch(keyword);
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
