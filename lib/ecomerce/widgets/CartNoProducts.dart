
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/helpers/app_themes.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/screens/navigation_files/MainScreen.dart';
import 'package:provider/provider.dart';
class CartNoProducts extends StatelessWidget {
  final PageController controller;
  CartNoProducts({@required this.controller});
  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<Languages>(context);
    return Container(
      width: MediaQuery.of(context).size.width / 1.6,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              CupertinoIcons.cart_badge_plus,
              size: 80,
              color:Colors.deepPurple.withOpacity(0.7),
            ),
            Text(
              lang.translation['youDidNotAddToCart']
              [Languages.selectedLanguage],
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontFamily: fonts,
                color: Theme.of(context).bottomAppBarColor.withOpacity(0.4),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                child: Text(
                  lang.translation['startShopping'][Languages.selectedLanguage],
                  style: TextStyle(
                      fontFamily: fonts,
                      color: Colors.white, fontSize: 16),
                ),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.of(context).pushReplacement(CupertinoPageRoute(
                    builder: (context) => MainScreen(),
                  ));
                },
              ),
            )
          ],
        ),
      ),
    );}}