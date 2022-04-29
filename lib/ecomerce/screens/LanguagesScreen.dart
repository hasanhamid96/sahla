import 'package:back_button_interceptor/back_button_interceptor.dart';

import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/helpers/font.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/services/helpers/RestartWidget.dart';
import 'package:provider/provider.dart';

class LanguagesScreen extends StatefulWidget {
  @override
  State<LanguagesScreen> createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  bool arabic_selected = true;

  bool english_selected = false;

  @override
  Widget build(BuildContext context) {
    final allPro = Provider.of<AllProviders>(context);
    final lang = Provider.of<Languages>(context);
    return WillPopScope(
      onWillPop: () {
        print("sas");
        allPro.NavBarShow(true);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: Theme.of(context).primaryColor,
          iconTheme: IconThemeData(color: Colors.white),
          leading: new Container(),
          actions: <Widget>[
            Languages.selectedLanguage == 0
                ? Container(
                    width: MediaQuery.of(context).size.width / 1.1,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            allPro.NavBarShow(true);
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                        Text(
                          lang.translation['LanguageTitle']
                              [Languages.selectedLanguage],
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: fonts,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ))
                : Container(
                    width: MediaQuery.of(context).size.width / 1.1,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          lang.translation['LanguageTitle']
                              [Languages.selectedLanguage],
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: fonts,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            allPro.NavBarShow(true);
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ],
                    ))
          ],
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    lang.saveLanguageIndex(0);
                    Languages.selectedLanguage = 0;
                    lang.saveLanguageIndex(0);
                    //setState(() {});
                    //Navigator.of(context).pop();
                    allPro.onceCategory = false;
                    allPro.isCategoryOffline = true;
                    allPro.isPostsOk = false;
                    allPro.isProductsMainOk = false;
                    allPro.onceGetProductsParam = false;
                    allPro.onceStyle = false;
                    allPro.loadedAllProductsMain = [];
                    allPro.currentPostsUrl =
                        "${AllProviders.hostName}/api/v1/products?lang=";
                    allPro.fetchStyle();
                    // Navigator.of(context).pop();
                    RestartWidget.restartApp(context);
                  },
                  child: Container(
                    margin: Languages.selectedLanguage == 0
                        ? EdgeInsets.only(right: 15)
                        : EdgeInsets.only(left: 15),
                    alignment: Languages.selectedLanguage == 0
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Text(
                      "",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: fonts,
                          color: Theme.of(context).bottomAppBarColor),
                    ),
                  ),
                ),
                Divider(),
                InkWell(
                  onTap: () {
                    lang.saveLanguageIndex(1);
                    Languages.selectedLanguage = 1;
                    lang.saveLanguageIndex(1);
                    allPro.onceCategory = false;
                    allPro.isCategoryOffline = true;
                    allPro.isPostsOk = false;
                    allPro.isProductsMainOk = false;
                    allPro.onceGetProductsParam = false;
                    allPro.onceStyle = false;
                    allPro.loadedAllProductsMain = [];
                    allPro.currentPostsUrl =
                        "${AllProviders.hostName}/api/v1/products?lang=";
                    allPro.fetchStyle();
                    setState(() {
                      allPro.NavBarShow(false);
                    });
                    RestartWidget.restartApp(context);
                    // Navigator.of(context).pop();
                    // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => StartScreen(),) );
                    // Navigator.of(context).pop();
                  },
                  child: Container(
                    alignment: Languages.selectedLanguage == 0
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    margin: Languages.selectedLanguage == 0
                        ? EdgeInsets.only(right: 15)
                        : EdgeInsets.only(left: 15),
                    child: Text(
                      "English Language",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontFamily: fonts,
                          fontSize: 20,
                          color: Theme.of(context).bottomAppBarColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
