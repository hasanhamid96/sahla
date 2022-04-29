import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

class serviceShimmer extends StatelessWidget {
  const serviceShimmer({
    Key key,
    @required this.mediaQuery,
  }) : super(key: key);
  final Size mediaQuery;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black87,
      highlightColor: Colors.white,
      period: Duration(milliseconds: 700),
      child: Container(
        margin: EdgeInsets.all(8),
        width: mediaQuery.width,
        height: mediaQuery.height,
        child: StaggeredGridView.countBuilder(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          itemCount: 4,
          itemBuilder: (context, index) => Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(8),
            width: mediaQuery.width * 0.45,
            height: mediaQuery.height * 0.3,
            decoration: BoxDecoration(
              color: Colors.transparent,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.1),
                  blurRadius: 0.0,
                  spreadRadius: 0.1, // has the effect of extending the shadow
                  offset: Offset(
                    0, // horizontal, move right 10
                    0, // vertical, move down 10
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SectionShimmer extends StatelessWidget {
  const SectionShimmer({
    Key key,
    @required this.mediaQuery,
  }) : super(key: key);
  final Size mediaQuery;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      width: mediaQuery.width * 0.8,
      height: mediaQuery.height * 0.3,
      child: Shimmer.fromColors(
        baseColor: Colors.black87,
        highlightColor: Colors.white,
        period: Duration(milliseconds: 700),
        child: ListView(scrollDirection: Axis.horizontal, children: [
          Container(
            margin: EdgeInsets.all(8),
            width: mediaQuery.width * 0.9,
            height: mediaQuery.height * 0.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.transparent,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.1),
                  blurRadius: 0.0,
                  spreadRadius: 0.1, // has the effect of extending the shadow
                  offset: Offset(
                    0, // horizontal, move right 10
                    0, // vertical, move down 10
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
