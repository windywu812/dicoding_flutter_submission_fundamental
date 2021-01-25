import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmeringBox extends StatelessWidget {
  const ShimmeringBox({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 32,
      height: 130.0,
      child: Shimmer.fromColors(
        baseColor: Colors.grey,
        highlightColor: Colors.white,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
