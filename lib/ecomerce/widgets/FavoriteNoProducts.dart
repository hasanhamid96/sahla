
import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:provider/provider.dart';
class FavoriteNoProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<Languages>(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.favorite,
              size: 80,
              color: Theme.of(context).bottomAppBarColor.withOpacity(0.2),
            ),
            Text(
              lang.translation['noFacoriteProducts']
              [Languages.selectedLanguage],
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).bottomAppBarColor.withOpacity(0.4),
              ),
            ),
            // Container(
            //   margin: EdgeInsets.only(top: 30),
            //   child: RaisedButton(
            //     padding: EdgeInsets.all(12),
            //     child: Text(
            //       lang.translation['addMoreFavorite']
            //           [Languages.selectedLanguage],
            //       style: TextStyle(color: Colors.white, fontSize: 23),
            //     ),
            //     color: Theme.of(context).primaryColor,
            //     onPressed: () {},
            //   ),
            // )
          ],
        ),
      ),
    );}}