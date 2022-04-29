import 'package:connectivity/connectivity.dart';

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:new_sahla/draweer.dart';
import 'package:new_sahla/ecomerce/model/news.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/providers/UserProvider.dart';
import 'package:new_sahla/ecomerce/screens/CategoriesScreen.dart';
import 'package:new_sahla/ecomerce/templetes/ProductMainTemplate.dart';
import 'package:new_sahla/ecomerce/templetes/SliderTemplate.dart';
import 'package:new_sahla/ecomerce/templetes/post_temp.dart';
import 'package:new_sahla/services/templetes/category_home_template.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ansicolor/ansicolor.dart';

import '../NewsScreen.dart';

class HomeScreen extends StatefulWidget {
  final PageController controller;
  HomeScreen({this.controller});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }

    var scrollController = ScrollController();

    bool isLoading = false;

    @override
    void didChangeDependencies() {
      // TODO: implement didChangeDependencies
      super.didChangeDependencies();
      scrollController = ScrollController();
    }

    @override
    void initState() {
      // TODO: implement initState
      super.initState();
      Provider.of<UserProvider>(context, listen: false).getProfile();
      final allPro = Provider.of<AllProviders>(context, listen: false);
      allPro.getCartItems();
    }

    @override
    Widget build(BuildContext context) {
      final allposts = Provider.of<AllProviders>(context, listen: true);
      final lang = Provider.of<Languages>(context);
      // OneSignal.shared
      //     .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // allposts.fetchDataProduct(
      // int.parse(result.notification.payload.additionalData['index']));
      // AllProviders.isProductSimilarMainOk = false;
      // AllProviders.onceSimilar = false;
      // AllProviders.isProductOk = false;
      // AllProviders.selectedPiece = null;
      // Navigator.push(
      // context,
      // MaterialPageRoute(
      // builder: (context) => PressedProduct(
      // isMain: false,
      // ),
      // ),
      // );
      // });

      scrollController.addListener(() {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 800) {
          if (allposts.waitingForUrl == false &&
              allposts.currentPostsUrl !=
                  "null&lang=${Languages
                      .selectedLanguageStr}&sort=${AllProviders
                      .sortByElement}&type=${AllProviders.sortByElementType}") {
            print("start loading...");
            // setState(() {});
            allposts.fetchDataAllProducts();
            print("end");
          }
        }
        // if (controller.position.atEdge) {
        //   if (controller.position.pixels == 0) {
        //   } else {}
        // }
      });
      Provider.of<UserProvider>(context, listen: false).checkLogin();
      double sizeBetweenWidgets = 20;
      Future.delayed(const Duration(milliseconds: 700), () async {
        if (lang.onceChangeMain == false) {
          lang.onceChangeMain = true;
          var connectivityResult = await (Connectivity().checkConnectivity());
          if (connectivityResult == ConnectivityResult.mobile) {
            // I am connected to a mobile network.
            setState(() {
              // Languages.selectedLanguage == 0
              // ? widget.controller.jumpToPage(4)
              //     : widget.controller.jumpToPage(0);
            });
          } else if (connectivityResult == ConnectivityResult.wifi) {
            // I am connected to a wifi network.
            // setState(() {
            // Languages.selectedLanguage == 0
            // ? widget.controller.jumpToPage(4)
            //     : widget.controller.jumpToPage(0);
            // });
          } else {
            // I am not connected to anything
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) {
                return AlertDialog(
                  actions: <Widget>[
                    RaisedButton(
                      color: Colors.redAccent,
                      onPressed: () {
                        lang.onceChangeMain = false;
                        // setPro.dataOfflineAllCategories = null;
                        // setPro.fetchDataCategories();
                        Phoenix.rebirth(context);
                      },
                      child: Text(
                        lang.translation['noInternetConeectionRetryButton']
                        [Languages.selectedLanguage],
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                  content: Text(
                    lang.translation['noInternetConeection']
                    [Languages.selectedLanguage],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 35),
                  ),
                  title: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.warning,
                          color: Colors.redAccent,
                          size: 40,
                        ),
                      ],
                    ),
                  ),
                  elevation: 2,
                );
              },
            );
          }
        }
      });
      var dir = Languages.selectedLanguage == 0
          ? TextDirection.rtl
          : TextDirection.ltr;
      return Directionality(
        textDirection: dir,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          drawer: Drawers(isService: false,),
          appBar: AppBar(
            elevation: 0,
            leading: Container(
              margin: EdgeInsets.all(6),
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .appBarTheme
                    .color,
                shape: BoxShape.circle,
              ),
              child: Builder(
                builder: (ctx) =>
                    InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () {
                        Scaffold.of(ctx).openDrawer();
                      },
                      child: Icon(Icons.menu),
                    ),
              ),
            ),
            backgroundColor: Colors.transparent,
            // leading: Icon(Icons.menu),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              var style = Provider.of<AllProviders>(context, listen: false);
              setState(() {
                isLoading = true;
              });
              style.onceStyle = false;
              style.fetchStyle().then((value) {
                setState(() {
                  isLoading = false;
                });
              });
              final allposts = Provider.of<AllProviders>(
                  context, listen: false);
              scrollController.addListener(() {
                if (scrollController.position.pixels >=
                    scrollController.position.maxScrollExtent - 800) {
                  if (allposts.waitingForUrl == false &&
                      allposts.currentPostsUrl !=
                          "null&lang=${Languages
                              .selectedLanguageStr}&sort=${AllProviders
                              .sortByElement}&type=${AllProviders
                              .sortByElementType}") {
                    print("start loading...");
                    // setState(() {});
                    allposts.fetchDataAllProducts();
                    print("end");
                  }
                }
                // if (controller.position.atEdge) {
                //   if (controller.position.pixels == 0) {
                //   } else {}
                // }
              });
            },
            child: isLoading ? Column(
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.black87,
                  highlightColor: Colors.white,
                  period: Duration(milliseconds: 700),
                  child: Container(
                    height: 230,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.1),
                          blurRadius: 0.0,
                          spreadRadius:
                          0.1, // has the effect of extending the shadow
                          offset: Offset(
                            0, // horizontal, move right 10
                            0, // vertical, move down 10
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Shimmer.fromColors(
                    baseColor: Colors.black87,
                    highlightColor: Colors.white,
                    period: Duration(milliseconds: 700),
                    child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 1.1,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: 80,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.1),
                                      blurRadius: 0.0,
                                      spreadRadius:
                                      0.1,
                                      // has the effect of extending the shadow
                                      offset: Offset(
                                        0, // horizontal, move right 10
                                        0, // vertical, move down 10
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: 180,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.1),
                                      blurRadius: 0.0,
                                      spreadRadius:
                                      0.1,
                                      // has the effect of extending the shadow
                                      offset: Offset(
                                        0, // horizontal, move right 10
                                        0, // vertical, move down 10
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width / 1.1,
                            height:
                            MediaQuery
                                .of(context)
                                .size
                                .height / 5.6,
                            decoration: BoxDecoration(
                              //color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.1),
                                  blurRadius: 0.0,
                                  spreadRadius:
                                  0.1, // has the effect of extending the shadow
                                  offset: Offset(
                                    0, // horizontal, move right 10
                                    0, // vertical, move down 10
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
                SizedBox(height: 20,),
                Shimmer.fromColors(
                    baseColor: Colors.black87,
                    highlightColor: Colors.white,
                    period: Duration(milliseconds: 700),
                    child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 1.1,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: 80,
                                height: 30,
                              ),
                              Container(
                                width: 180,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.1),
                                      blurRadius: 0.0,
                                      spreadRadius:
                                      0.1,
                                      // has the effect of extending the shadow
                                      offset: Offset(
                                        0, // horizontal, move right 10
                                        0, // vertical, move down 10
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ))
              ],
            ) : SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 36,),
                  //slider
                  Consumer<AllProviders>(
                    builder: (ctx, pro, _) {
                      if (pro.isEverythingOkSider == false) {
                        return Shimmer.fromColors(
                          baseColor: Colors.black87,
                          highlightColor: Colors.white,
                          period: Duration(milliseconds: 700),
                          child: Container(
                            height: 230,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.1),
                                  blurRadius: 0.0,
                                  spreadRadius:
                                  0.1, // has the effect of extending the shadow
                                  offset: Offset(
                                    0, // horizontal, move right 10
                                    0, // vertical, move down 10
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      } else {
                        return SliderTemplate();
                        // return Container();
                      }
                    },
                  ),
                  SizedBox(
                    height: sizeBetweenWidgets,
                  ),
                  Column(
                    children: <Widget>[
                      //main category
                      Consumer<AllProviders>(
                        builder: (ctx, pro, _) {
                          if (pro.isCategoryOffline == true) {
                            return Shimmer.fromColors(
                                baseColor: Colors.black87,
                                highlightColor: Colors.white,
                                period: Duration(milliseconds: 700),
                                child: Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width / 1.1,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            width: 80,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.white
                                                      .withOpacity(
                                                      0.1),
                                                  blurRadius: 0.0,
                                                  spreadRadius:
                                                  0.1,
                                                  // has the effect of extending the shadow
                                                  offset: Offset(
                                                    0,
                                                    // horizontal, move right 10
                                                    0, // vertical, move down 10
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: 180,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.white
                                                      .withOpacity(
                                                      0.1),
                                                  blurRadius: 0.0,
                                                  spreadRadius:
                                                  0.1,
                                                  // has the effect of extending the shadow
                                                  offset: Offset(
                                                    0,
                                                    // horizontal, move right 10
                                                    0, // vertical, move down 10
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Container(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width / 1.1,
                                        height:
                                        MediaQuery
                                            .of(context)
                                            .size
                                            .height / 5.6,
                                        decoration: BoxDecoration(
                                          //color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.white.withOpacity(
                                                  0.1),
                                              blurRadius: 0.0,
                                              spreadRadius:
                                              0.1,
                                              // has the effect of extending the shadow
                                              offset: Offset(
                                                0, // horizontal, move right 10
                                                0, // vertical, move down 10
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ));
                          } else if (pro.catEnable == 1) {
                            return Column(
                              children: <Widget>[
                                Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width / 1.1,
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children:
                                      // Languages.selectedLanguage == 0
                                      //     ?
                                      <Widget>[
                                        Text(
                                          lang.translation['shopInCategories']
                                          [Languages.selectedLanguage],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Theme
                                                  .of(context)
                                                  .bottomAppBarColor,
                                              fontFamily: fonts,
                                              fontSize: 20),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CategoriesScreen(),
                                                ));
                                            // widget.controller.jumpToTab(3);
                                            // if (Languages.selectedLanguage == 0) {
                                            //   pageController.jumpToPage(2);
                                            // } else {
                                            //   pageController.jumpToPage(1);
                                            // }
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                lang.translation['moreTitle']
                                                [Languages.selectedLanguage],
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Theme
                                                        .of(context)
                                                        .accentColor,
                                                    fontFamily: fonts,
                                                    fontSize: 15),
                                              ),
                                              Icon(
                                                Languages.selectedLanguage == 0
                                                    ? Icons.keyboard_arrow_left
                                                    : Icons
                                                    .keyboard_arrow_right,
                                                size: 18,
                                                color: Theme
                                                    .of(context)
                                                    .accentColor,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]
                                  ),
                                ),
                                SizedBox(
                                  height: sizeBetweenWidgets,
                                ),
                                Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .height / 5.6,
                                  //margin: EdgeInsets.only(right: 10, left: 10),
                                  child: Center(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: pro.categories.length,
                                      itemBuilder: (ctx, index) {
                                        return CategoryHomeTemplate(
                                            category: pro.categories[index]);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return SizedBox();
                          }
                        },
                      ),
                      SizedBox(
                        height: sizeBetweenWidgets,
                      ),
                      //offers
                      Consumer<AllProviders>(
                        builder: (ctx, pro, _) {
                          if (pro.isPostsOk == false) {
                            return Shimmer.fromColors(
                                baseColor: Colors.black87,
                                highlightColor: Colors.white,
                                period: Duration(milliseconds: 700),
                                child: Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width / 1.1,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            width: 80,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.white
                                                      .withOpacity(
                                                      0.1),
                                                  blurRadius: 0.0,
                                                  spreadRadius:
                                                  0.1,
                                                  // has the effect of extending the shadow
                                                  offset: Offset(
                                                    0,
                                                    // horizontal, move right 10
                                                    0, // vertical, move down 10
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: 180,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.white
                                                      .withOpacity(
                                                      0.1),
                                                  blurRadius: 0.0,
                                                  spreadRadius:
                                                  0.1,
                                                  // has the effect of extending the shadow
                                                  offset: Offset(
                                                    0,
                                                    // horizontal, move right 10
                                                    0, // vertical, move down 10
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Container(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width / 1.1,
                                        height:
                                        MediaQuery
                                            .of(context)
                                            .size
                                            .height / 5.6,
                                        decoration: BoxDecoration(
                                          //color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.white.withOpacity(
                                                  0.1),
                                              blurRadius: 0.0,
                                              spreadRadius:
                                              0.1,
                                              // has the effect of extending the shadow
                                              offset: Offset(
                                                0, // horizontal, move right 10
                                                0, // vertical, move down 10
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ));
                          } else if (pro.postEnable == 1) {
                            return Column(
                              children: <Widget>[
                                Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width / 1.1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children:
                                    // Languages.selectedLanguage == 0
                                    //     ?
                                    <Widget>[
                                      Text(
                                        lang.translation['latestNews']
                                        [Languages.selectedLanguage],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Theme
                                                .of(context)
                                                .bottomAppBarColor,
                                            fontFamily: fonts,
                                            fontSize: 20),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    NewsScreen(),
                                              ));
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          NewsScreen(),
                                                    ));
                                              },
                                              child: Text(
                                                lang.translation['moreTitle']
                                                [Languages.selectedLanguage],
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Theme
                                                        .of(context)
                                                        .accentColor,
                                                    fontFamily: fonts,
                                                    fontSize: 15),
                                              ),
                                            ),
                                            Icon(
                                                Languages.selectedLanguage == 0
                                                    ? Icons.keyboard_arrow_left
                                                    : Icons
                                                    .keyboard_arrow_right,
                                                size: 18,
                                                color: Theme
                                                    .of(context)
                                                    .accentColor),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(bottom: 25),
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width * 1,
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .height * 0.2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(7),
                                    ),),
                                  child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: allposts.posts
                                          .map((item) {
                                        return PostsHomeTemplate(
                                          news: News(
                                              id: item.id,
                                              title: item.title,
                                              text: item.text,
                                              image: item.image,
                                              date: item.date,
                                              productId: item.productId
                                          ),
                                          home: true,
                                        );
                                      }).toList()
                                  ),
                                ),
                                SizedBox(
                                  height: sizeBetweenWidgets,
                                ),
                              ],
                            );
                          } else {
                            return SizedBox();
                          }
                        },
                      ),
                      Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width / 1.1,
                        child: Row(
                          // mainAxisAlignment: Languages.selectedLanguage == 0
                          //     ? MainAxisAlignment.end
                          //     : MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                lang.translation['discoverMore']
                                [Languages.selectedLanguage],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Theme
                                        .of(context)
                                        .bottomAppBarColor,
                                    fontFamily: fonts,
                                    fontSize: 20),
                              ),
                            ]),
                      ),
                      Transform.translate(
                        offset: Offset(0, -90),
                        child: Consumer<AllProviders>(
                          builder: (ctx, pro, _) {
                            if (pro.isProductsMainOk == false) {
                              return Shimmer.fromColors(
                                  baseColor: Colors.black87,
                                  highlightColor: Colors.white,
                                  period: Duration(milliseconds: 700),
                                  child: Container(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width / 1.1,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              width: 80,
                                              height: 30,
                                            ),
                                            Container(
                                              width: 180,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(20),
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.white
                                                        .withOpacity(0.1),
                                                    blurRadius: 0.0,
                                                    spreadRadius:
                                                    0.1,
                                                    // has the effect of extending the shadow
                                                    offset: Offset(
                                                      0,
                                                      // horizontal, move right 10
                                                      0, // vertical, move down 10
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ));
                            } else {
                              return Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                margin: EdgeInsets.only(top: 10),
                                // height: 500,
                                child: GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 0.75
                                  ),
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemCount: allposts.allProducts.length,
                                  itemBuilder: (BuildContext context,
                                      int index) =>
                                      ProductMainTemplate(
                                        product: allposts.allProducts[index],
                                        isMain: false,
                                      ),
                                ),
                              );
                              // Container(
                              //   width: MediaQuery.of(context).size.width / 1.1,
                              //   //height: MediaQuery.of(context).size.height / 4.1,
                              //   child: GridView.builder(
                              //     itemCount: allposts.allProducts.length,
                              //     gridDelegate:
                              //         SliverGridDelegateWithFixedCrossAxisCount(
                              //       crossAxisCount: 2,
                              //       childAspectRatio: 0.6 / 1,
                              //       crossAxisSpacing: 10,
                              //       mainAxisSpacing: 15,
                              //       // crossAxisSpacing: 0,
                              //       // mainAxisSpacing: 0,
                              //     ),
                              //     itemBuilder: (ctx, index) {
                              //       return ProductMainTemplate(
                              //         product: allposts.allProducts[index],
                              //         isMain: false,
                              //       );
                              //     },
                              //     physics: NeverScrollableScrollPhysics(),
                              //     shrinkWrap: true,
                              //   ),
                              // ),
                            }
                          },
                        ),
                      ),
                      allposts.waitingForUrl &&
                          allposts.currentPostsUrl !=
                              "null&lang=${Languages
                                  .selectedLanguageStr}&sort=${AllProviders
                                  .sortByElement}&type=${AllProviders
                                  .sortByElementType}"
                          ? CircularProgressIndicator()
                          : SizedBox(),
                      SizedBox(
                        height: 80,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
}
