import 'package:back_button_interceptor/back_button_interceptor.dart';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:new_sahla/ecomerce/helpers/font.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final allPro = Provider.of<AllProviders>(context, listen: false);
    final lang = Provider.of<Languages>(context);
    return WillPopScope(
      onWillPop: () {
        allPro.NavBarShow(true);
        return Future.value(true);
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.color,
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
                            lang.translation['aboutUs']
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
                            lang.translation['aboutUs']
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
                      ),
                    )
            ],
          ),
          body:
              // application.offlieContactUs != true
              //     ?
              FutureBuilder(
            future: allPro.fetchDataInfo(),
            builder: (ctx, authResultSnap) {
              if (authResultSnap.connectionState == ConnectionState.waiting) {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Center(child: CircularProgressIndicator()));
              } else {
                return AboutUsWidget(lang: lang, application: allPro);
              }
            },
          )
          // : AboutUsWidget(lang: lang, application: application),
          ),
    );
  }
}

class AboutUsWidget extends StatelessWidget {
  const AboutUsWidget({
    Key key,
    @required this.lang,
    @required this.application,
  }) : super(key: key);
  final Languages lang;
  final AllProviders application;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color:
                          Theme.of(context).bottomAppBarColor.withOpacity(0.2),
                      spreadRadius: 0.4,
                      blurRadius: 2,
                      offset: Offset(0, 3)),
                ],
              ),
              child: SelectableText(
                application.aboutus,
                textAlign: TextAlign.center,
                //textDirection: TextDirection.rtl,
                style: TextStyle(
                    fontSize: 23,
                    color: Colors.blueGrey,
                    fontFamily: fonts,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Text(
                    lang.translation['socialMedia'][Languages.selectedLanguage],
                    style: TextStyle(
                      color: Theme.of(context).bottomAppBarColor,
                      fontFamily: fonts,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      application.facebook != null
                          ? InkWell(
                              onTap: () async {
                                final url = application.facebook;
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                              child: Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: Theme.of(context)
                                            .bottomAppBarColor
                                            .withOpacity(0.2),
                                        spreadRadius: 0.4,
                                        blurRadius: 2,
                                        offset: Offset(0, 3)),
                                  ],
                                ),
                                child: Icon(
                                  FontAwesome.facebook,
                                  size: 30,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            )
                          : SizedBox(),
                      application.insta != null
                          ? InkWell(
                              onTap: () async {
                                final url = application.insta;
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                              child: Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: Theme.of(context)
                                            .bottomAppBarColor
                                            .withOpacity(0.2),
                                        spreadRadius: 0.4,
                                        blurRadius: 2,
                                        offset: Offset(0, 3)),
                                  ],
                                ),
                                child: Icon(
                                  FontAwesome.instagram,
                                  size: 30,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            )
                          : SizedBox(),
                      application.youtube != null
                          ? InkWell(
                              onTap: () async {
                                final url = application.youtube;
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                              child: Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: Theme.of(context)
                                            .bottomAppBarColor
                                            .withOpacity(0.2),
                                        spreadRadius: 0.4,
                                        blurRadius: 2,
                                        offset: Offset(0, 3)),
                                  ],
                                ),
                                child: Icon(
                                  FontAwesome.youtube,
                                  size: 30,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            )
                          : SizedBox(),
                      application.twitter != null
                          ? InkWell(
                              onTap: () async {
                                final url = application.twitter;
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                              child: Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: Theme.of(context)
                                            .bottomAppBarColor
                                            .withOpacity(0.2),
                                        spreadRadius: 0.4,
                                        blurRadius: 2,
                                        offset: Offset(0, 3)),
                                  ],
                                ),
                                child: Icon(
                                  FontAwesome.twitter,
                                  size: 30,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            )
                          : SizedBox(),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
