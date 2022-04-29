
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/helpers/app_themes.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/screens/navigation_files/MainScreen.dart';
import 'package:provider/provider.dart';
class OrderDone extends StatelessWidget {
  final PageController controller;
  OrderDone({this.controller});
  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<Languages>(context);
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                CupertinoIcons.checkmark_seal_fill,
                size: 100,
                color: Colors.deepPurple,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  lang.translation['orderDoneConti']
                  [Languages.selectedLanguage],
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    fontFamily: fonts,
                    color: Theme.of(context).bottomAppBarColor.withOpacity(0.4),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 69,vertical: 10),
                  child: Text(
                    lang.translation['OK'][Languages.selectedLanguage],
                    style: TextStyle(color: Colors.white, fontSize: 18,fontFamily: fonts),
                  ),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(context,
                        CupertinoPageRoute(builder: (context) =>
                            MainScreen(),), (route) => false);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );}}