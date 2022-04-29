import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/providers/UserProvider.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/ecomerce/screens/LoginScreen.dart';
import 'package:new_sahla/ecomerce/templetes/OrderHistoryItem.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class OrderHistoryScreen extends StatefulWidget {
  PageController controller;

  OrderHistoryScreen({this.controller});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  int pageIndex;

  bool isLoading = true;

  Future<bool> buildShowCupertinoDialog(BuildContext context) {
    var dir =
        Languages.selectedLanguage == 0 ? TextDirection.rtl : TextDirection.ltr;
    return showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => WillPopScope(
        onWillPop: () async {
          if (!UserProvider.isLogin)
            widget.controller
                .jumpToPage(Languages.selectedLanguage == 0 ? 4 : 0);
          return false;
        },
        child: CupertinoAlertDialog(
          insetAnimationCurve: Curves.easeInOutBack,
          content: Text(
            Languages.selectedLanguage == 0
                ? "لم تسجل بعد؟"
                : 'you did not register yet?',
            textDirection: dir,
            style: Theme.of(context).textTheme.headline3,
          ),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(context);
                widget.controller
                    .jumpToPage(Languages.selectedLanguage == 0 ? 4 : 0);
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => LoginScreen(),
                    ));
              },
              child: Text(
                Languages.selectedLanguage == 0 ? 'سجل الان' : 'register now',
                textDirection: dir,
                style: TextStyle(
                    color: Colors.blue, fontFamily: fonts, fontSize: 16),
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                setState(() {
                  Navigator.pop(context);
                  widget.controller
                      .jumpToPage(Languages.selectedLanguage == 0 ? 4 : 0);
                });
              },
              child: Text(
                Languages.selectedLanguage == 0 ? 'رجوع' : 'back',
                textDirection: dir,
                style: TextStyle(
                    color: Colors.blue, fontFamily: fonts, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    AllProviders allPro;
    if (!UserProvider.isLogin)
      Future.delayed((Duration(seconds: 1))).then((value) {
        buildShowCupertinoDialog(context);
      });
    else {
      allPro = Provider.of<AllProviders>(context, listen: false);
      allPro.getOrders().then((value) {
        setState(() {
          isLoading = false;
        });
      }).catchError((onError) {
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<Languages>(context);
    @override
    final allPro = Provider.of<AllProviders>(context);
    var dir =
        Languages.selectedLanguage == 0 ? TextDirection.rtl : TextDirection.ltr;
    return Directionality(
      textDirection: dir,
      child: WillPopScope(
        onWillPop: () {
          allPro.NavBarShow(true);
          return Future.value(true);
        },
        child: DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              automaticallyImplyLeading: false,
              bottom: TabBar(
                // controller: controller,
                tabs: <Tab>[
                  Tab(
                    child: Text(
                      lang.translation['recentOrdersTitle']
                          [Languages.selectedLanguage],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Tab(
                    child: Text(
                      lang.translation['oldOrdersTitle']
                          [Languages.selectedLanguage],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              title: Text(
                lang.translation['oldOrdersTitle'][Languages.selectedLanguage],
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
            ),
            body: isLoading
                ? OrderShimmer()
                : TabBarView(
                    // physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      Consumer<AllProviders>(
                        builder: (ctx, pro, _) {
                          if (pro.isProductOrderOk == false) {
                            return OrderShimmer();
                          } else if (allPro.allOrdersItems.isEmpty)
                            return Container(
                              margin: EdgeInsets.only(top: 50),
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.not_interested,
                                      size: 40,
                                      color: Theme.of(context)
                                          .bottomAppBarColor
                                          .withOpacity(0.2),
                                    ),
                                    Text(
                                      Languages.selectedLanguage == 0
                                          ? "لا توجد أوامر معلقة"
                                          : "No Pending orders",
                                      textDirection: TextDirection.rtl,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: fonts,
                                        color: Theme.of(context)
                                            .bottomAppBarColor
                                            .withOpacity(0.4),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          else {
                            return RefreshIndicator(
                              onRefresh: () => _refresh(allPro),
                              child: ListView.builder(
                                itemCount:
                                    allPro.allOrdersItems.reversed.length,
                                itemBuilder: (context, index) {
                                  if (allPro.allOrdersItems.reversed
                                          .toList()[index]
                                          .status !=
                                      'delivered') {
                                    return OrderHistoryItem(
                                      order: allPro.allOrdersItems.reversed
                                          .toList()[index],
                                    );
                                  } else {
                                    return SizedBox();
                                  }
                                },
                              ),
                            );
                          }
                        },
                      ),
                      Consumer<AllProviders>(
                        builder: (ctx, pro, _) {
                          if (pro.isProductOrderOk == false) {
                            return OrderShimmer();
                          } else if (allPro.allOrdersItems.isEmpty)
                            return Container(
                              margin: EdgeInsets.only(top: 50),
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.not_interested,
                                      size: 40,
                                      color: Theme.of(context)
                                          .bottomAppBarColor
                                          .withOpacity(0.2),
                                    ),
                                    Text(
                                      Languages.selectedLanguage == 0
                                          ? "لا توجد أوامر قديمة"
                                          : "There is No Old Orders",
                                      textDirection: TextDirection.rtl,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: fonts,
                                        color: Theme.of(context)
                                            .bottomAppBarColor
                                            .withOpacity(0.4),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          else {
                            return RefreshIndicator(
                              onRefresh: () => _refresh(allPro),
                              child: ListView.builder(
                                itemCount:
                                    allPro.allOrdersItems.reversed.length,
                                itemBuilder: (context, index) {
                                  if (allPro.allOrdersItems.reversed
                                          .toList()[index]
                                          .status ==
                                      'delivered') {
                                    return OrderHistoryItem(
                                      order: allPro.allOrdersItems.reversed
                                          .toList()[index],
                                    );
                                  } else {
                                    return SizedBox();
                                  }
                                },
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _refresh(allpro) async {
    // allpro.isProductOrderOk = false;
    allpro.getOrders();
    setState(() {});
  }
}

class OrderShimmer extends StatelessWidget {
  const OrderShimmer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Shimmer.fromColors(
        baseColor: Colors.black87,
        highlightColor: Colors.white,
        period: Duration(milliseconds: 700),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (int i = 0; i < 10; i++)
                Container(
                  margin: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.1,
                  decoration: BoxDecoration(
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
                ),
            ],
          ),
        ),
      ),
    );
  }
}
