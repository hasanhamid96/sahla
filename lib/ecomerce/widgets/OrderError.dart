
import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/helpers/app_themes.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:provider/provider.dart';
class OrderError extends StatelessWidget {
  final PageController controller;
  OrderError({this.controller});
  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<Languages>(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.error_outline,
                  size: 80,
                  color: Colors.redAccent,
                ),
                Text(
                  Languages.selectedLanguage == 0
                      ? "لا يمكن تنفيذ الطلب ، يرجى المحاولة مرة أخرى"
                      : "Order can't be done , Please try again",
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: fonts,
                    color: Theme.of(context).bottomAppBarColor.withOpacity(0.4),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: RaisedButton(
                    padding: EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Text(
                      lang.translation['OK'][Languages.selectedLanguage],
                      style: TextStyle(color: Colors.white, fontSize: 23,   fontFamily: fonts,),
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );}}