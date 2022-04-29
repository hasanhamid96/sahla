import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/providers/UserProvider.dart';
import 'package:new_sahla/ecomerce/screens/LoginScreen.dart';
import 'package:new_sahla/services/providers/Orders.dart';
import 'package:new_sahla/services/templetes/MyServiceItem.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class MyServiceScreen extends StatefulWidget {
  PageController controller;

  MyServiceScreen({Key key, this.controller})
      : super(
          key: key,
        );

  @override
  State<MyServiceScreen> createState() => _MyServiceScreenState();
}

class _MyServiceScreenState extends State<MyServiceScreen> {
  bool isLoading = false;

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
    // TODO: implement initState
    super.initState();
    if (!UserProvider.isLogin)
      Future.delayed((Duration(seconds: 1))).then((value) {
        buildShowCupertinoDialog(context);
      });
    else {
      isLoading = true;
      Provider.of<Orders>(context, listen: false).fetchMyOrders().then((value) {
        if (mounted)
          setState(() {
            isLoading = false;
          });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final lang = Provider.of<Languages>(context);
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            lang.translation['myService'][Languages.selectedLanguage],
            style: Theme.of(context).appBarTheme.textTheme.headline1,
          ),
          bottom: TabBar(
            labelPadding: EdgeInsets.all(10),
            tabs: [
              Text(
                lang.translation['DoneService'][Languages.selectedLanguage],
                style: Theme.of(context).appBarTheme.textTheme.headline1,
              ),
              Text(
                lang.translation['pendingService'][Languages.selectedLanguage],
                style: Theme.of(context).appBarTheme.textTheme.headline1,
              ),
            ],
          ),
        ),
        body: isLoading
            ? Shimmer.fromColors(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (int i = 0; i < 10; i++)
                        Container(
                          margin: EdgeInsets.all(10),
                          width: double.infinity,
                          height: mediaQuery.height * 0.13,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(140),
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                    ],
                  ),
                ),
                baseColor: Colors.black,
                highlightColor: Colors.white)
            : Consumer<Orders>(
                builder: (context, ord, child) {
                  return TabBarView(children: [
                    RefreshIndicator(
                      onRefresh: () async {
                        setState(() {
                          isLoading = true;
                        });
                        Provider.of<Orders>(context, listen: false)
                            .fetchMyOrders()
                            .then((value) {
                          setState(() {
                            isLoading = false;
                          });
                        });
                      },
                      child: ListView.builder(
                        itemCount: ord.pastServiceOrder.length,
                        itemBuilder: (context, index) => MyServiceItem(
                          order: ord.pastServiceOrder.toList()[index],
                        ),
                      ),
                    ),
                    RefreshIndicator(
                      onRefresh: () async {
                        setState(() {
                          isLoading = true;
                        });
                        Provider.of<Orders>(context, listen: false)
                            .fetchMyOrders()
                            .then((value) {
                          setState(() {
                            isLoading = false;
                          });
                        });
                      },
                      child: ListView.builder(
                        itemCount: ord.recentServiceOrder.length,
                        itemBuilder: (context, index) => MyServiceItem(
                          order: ord.recentServiceOrder.toList()[index],
                        ),
                      ),
                    ),
                  ]);
                },
              ),
      ),
    );
  }
}
