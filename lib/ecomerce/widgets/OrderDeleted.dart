
import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:provider/provider.dart';
class OrderDeleted extends StatelessWidget {
  final PageController controller;
  OrderDeleted({this.controller});
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
                      ? "لا يمكن تنفيذ الطلب ، لقد حذف البائع بعض العناصر في سلة التسوق"
                      : "Order can't be done , the seller have delete some item in the cart ",
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).bottomAppBarColor.withOpacity(0.4),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: RaisedButton(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      lang.translation['OK'][Languages.selectedLanguage],
                      style: TextStyle(color: Colors.white, fontSize: 23),
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