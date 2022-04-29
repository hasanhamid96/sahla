import 'package:badges/badges.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:new_sahla/ecomerce/helpers/ecommerce_icons_icons.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/providers/UserProvider.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/ecomerce/screens/ProfileScreen.dart';
import 'package:new_sahla/ecomerce/screens/drawer_files/CartScreen.dart';
import 'package:new_sahla/services/providers/Orders.dart';
import 'package:new_sahla/services/screens/search_serv_screen.dart';
import 'package:new_sahla/services/templetes/drawer_item.dart';

import 'package:provider/provider.dart';

import '../../start_screen.dart';
import 'MainService.dart';
import 'MyServiceScreen.dart';
import 'fav_service_screen.dart';
import 'happy_client_center.dart';
class NavBottomServiceBar extends StatefulWidget {
  NavBottomServiceBar({Key key}) : super(key: key);

  @override
  State<NavBottomServiceBar> createState() => _NavBottomServiceBarState();
}

class _NavBottomServiceBarState extends State<NavBottomServiceBar> {
  var drawerKey;

  int selectedIndex = 0;

  bool _hideNavBar;

  List<BottomNavigationBarItem> _navBarsItems(context) {
    if (Languages.selectedLanguage == 1) {
      return [
        BottomNavigationBarItem(
          // translucencyPercentage: 85,
          icon: Icon(CupertinoIcons.home),
          title: Text(Languages.selectedLanguage == 0 ? 'خدمات' : "Services",
              style: Theme
                  .of(context)
                  .textTheme
                  .headline1),
          // activeColor: Theme.of(context).primaryColor,
          // inactiveColor: Colors.grey,
          // isTranslucent: true,
        ),
        BottomNavigationBarItem(
          // translucencyPercentage: 85,
          icon: Icon(CupertinoIcons.headphones),
          title: Text(
              Languages.selectedLanguage == 0 ? 'مساعدة' : "help", style: Theme
              .of(context)
              .textTheme
              .headline1),
          // activeColor: Theme.of(context).primaryColor,
          // inactiveColor: Colors.grey,
          // isTranslucent: true,
        ),
        BottomNavigationBarItem(
          // translucencyPercentage: 85,
          icon: Icon(EcommerceIcons.magnifying_glass),
          title: Text(
              Languages.selectedLanguage == 0 ? 'بحث' : "search", style: Theme
              .of(context)
              .textTheme
              .headline1),
          // activeColor: Theme.of(context).primaryColor,
          // inactiveColor: Colors.grey,
          // isTranslucent: true,
        ),
        BottomNavigationBarItem(
          // translucencyPercentage: 85,
          icon: Icon(CupertinoIcons.briefcase_fill),
          title: Text(
              Languages.selectedLanguage == 0 ? 'خدماتي' : "My Services",
              style: Theme
                  .of(context)
                  .textTheme
                  .headline1),
          // activeColor: Theme.of(context).primaryColor,
          // inactiveColor: Colors.grey,
          // isTranslucent: true,
        ),
        BottomNavigationBarItem(
          // translucencyPercentage: 85,
          icon: Icon(CupertinoIcons.arrow_uturn_left),
          title: Text(Languages.selectedLanguage == 0 ? 'الرئيسية' : "Main",
              style: Theme
                  .of(context)
                  .textTheme
                  .headline1),
          // activeColor: Theme.of(context).primaryColor,
          // inactiveColor: Colors.grey,
          // isTranslucent: true,
        ),
      ];
    } else {
      return [
        BottomNavigationBarItem(
          // translucencyPercentage: 85,
          icon: Icon(CupertinoIcons.arrow_uturn_left),
          title: Text(Languages.selectedLanguage == 0 ? 'الرئيسية' : "Main",
              style: Theme
                  .of(context)
                  .textTheme
                  .headline1),
          // activeColor: Theme.of(context).primaryColor,
          // inactiveColor: Colors.grey,
          // isTranslucent: true,
        ),
        BottomNavigationBarItem(
          icon:
          Consumer<Orders>(
            builder: (context, allpr, _) {
              if (allpr.pendingOrder != 0) {
                return Badge(
                  // animationType: BadgeAnimationType.scale,
                  badgeColor: Theme
                      .of(context)
                      .primaryColor,
                  animationDuration: Duration(milliseconds: 100),
                  badgeContent: Container(
                    //padding: EdgeInsets.only(top: 5),
                    child: Text(
                      allpr.pendingOrder != 0
                          ? allpr.pendingOrder.toString()
                          : 0,
                      style: TextStyle(color: Colors.white, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // position: BadgePosition.topStart(),
                  child: Icon(CupertinoIcons.briefcase_fill),
                );
              } else {
                return Icon(CupertinoIcons.briefcase_fill);
              }
            },
          ),
          title: Text(
              Languages.selectedLanguage == 0 ? 'خدماتي' : "My Services",
              style: Theme
                  .of(context)
                  .textTheme
                  .headline1),
        ),
        BottomNavigationBarItem(
          // translucencyPercentage: 85,
          icon: Icon(EcommerceIcons.magnifying_glass),
          title: Text(
            Languages.selectedLanguage == 0 ? 'بحث' : "search", style: Theme
              .of(context)
              .textTheme
              .headline1,),
          // activeColor: Theme.of(context).primaryColor,
          // inactiveColor: Colors.grey,
          // isTranslucent: true,
        ),
        BottomNavigationBarItem(
          // translucencyPercentage: 85,
          icon: Icon(CupertinoIcons.headphones),
          title: Text(
              Languages.selectedLanguage == 0 ? 'مساعدة' : "help", style: Theme
              .of(context)
              .textTheme
              .headline1),
          // activeColor: Theme.of(context).primaryColor,
          // inactiveColor: Colors.grey,
          // isTranslucent: true,
        ),
        BottomNavigationBarItem(
          // translucencyPercentage: 85,
          icon: Icon(CupertinoIcons.home),
          title: Text(Languages.selectedLanguage == 0 ? 'خدمات' : "Services",
              style: Theme
                  .of(context)
                  .textTheme
                  .headline1),
          // activeColor: Theme.of(context).primaryColor,
          // inactiveColor: Colors.grey,
          // isTranslucent: true,
        ),
      ];
    }
  }

  List<Widget> _buildScreens() {
  // _controller.jumpToTab(4);
  if (Languages.selectedLanguage == 0) {
  return [
  CartScreen(),
  MyServiceScreen(controller: _controller,),
  SearchService(),
  HappyClientCenter(),
  MainService(),
  ];
  } else {
  return [
  MainService(),
  HappyClientCenter(),
  SearchService(),
  MyServiceScreen(controller: _controller,),
  CartScreen(),
  ];
  }
  }

  PageController _controller;

  @override
  void initState() {
      // TODO: implement initState
      super.initState();
      selectedIndex = Languages.selectedLanguage==0?4:0;
  _controller=PageController(initialPage: Languages.selectedLanguage==0?4:0);
  }

  @override
  Widget build(BuildContext context) {
  final allPro = Provider.of<AllProviders>(context,listen: false);
  Provider.of<Languages>(context, listen: false).readLanguageIndex();
  return WillPopScope(
  onWillPop: () async {
  return await buildShowCupertinoDialog(context);
  },
  child: Scaffold(
  bottomNavigationBar: BottomNavigationBar(
  currentIndex: selectedIndex,
  backgroundColor: Colors.white,
  showUnselectedLabels: true,
  unselectedIconTheme: IconThemeData(
  color: Colors.grey
  ),
  selectedLabelStyle:TextStyle(color: Colors.black,fontSize: 15,fontFamily: fonts),
  unselectedLabelStyle:TextStyle(color: Colors.grey,fontSize: 14,fontFamily: fonts),
  onTap: onItemTapped,
  type: BottomNavigationBarType.fixed,
  selectedItemColor: Theme.of(context).primaryColor,
  items: _navBarsItems(context),
  ),
  body: PageView(
  physics: NeverScrollableScrollPhysics(),
  children: _buildScreens(),
  pageSnapping: false,
  reverse: false,
  controller: _controller,
  onPageChanged: onPageChanged,
  ),
  ),
  );}

  void onPageChanged(int page) {
  setState(() {
  this.selectedIndex = page;
  });}

  void onItemTapped(int index) {
    if (Languages.selectedLanguage == 0 && index == 0) {
      buildShowCupertinoDialog(context);
    }
    else if (Languages.selectedLanguage == 1 && index == 4) {
      buildShowCupertinoDialog(context);
    }
    else {
      setState(() {
        this._controller.jumpToPage(
          index,
        );
      });
    }
  }

  Future<bool> buildShowCupertinoDialog(BuildContext context) {
  var dir=Languages.selectedLanguage==0?TextDirection.rtl:TextDirection.ltr;
  return showCupertinoDialog(
  context: context,
  barrierDismissible: true,
  builder: (context) => CupertinoAlertDialog(
  insetAnimationCurve: Curves.easeInOutBack,
  content: Text(
  Languages.selectedLanguage==0?'العودة إلى الرئيسية؟':'back to main?',
  textDirection: dir,
  style: Theme.of(context).textTheme.headline3,
  ),
  actions: [
  CupertinoActionSheetAction(
  onPressed: () async {
  Navigator.pop(context);
  },
  child: Text(
  Languages.selectedLanguage==0?'لا':'no',
  textDirection: dir,
  style: TextStyle(color: Colors.blue,fontFamily: fonts,fontSize: 16),
  ),
  ),
  CupertinoActionSheetAction(
  onPressed: () {
  Navigator.of(context).pushAndRemoveUntil(CupertinoPageRoute(builder: (context) => StartScreen(),), (route) => false);
  },
  child: Text(
  Languages.selectedLanguage==0?'مخرج':'Exit',
  textDirection: dir,
  style: TextStyle(color: Colors.red,fontFamily: fonts,fontSize: 16),
  ),
  ),
  ],
  ),
  );}

  Widget buildBody(context) {
  return InkWell(
  onTap: () {
  if (drawerKey.currentState.isOpened())
  return drawerKey.currentState.closeDrawer();
  },
  child:MainService(drawerKey: drawerKey,)
  );}

  Future<bool> _onPopScpoe() {
  if (drawerKey.currentState.isOpened()) {
  drawerKey.currentState.closeDrawer();
  return Future.value(false);
  } else
  return Future.value(true);}

  Widget buildDrawer(context) {
  final lang =Provider.of<Languages>(context);
  return WillPopScope(
  onWillPop: _onPopScpoe,
  child: Container(
  child: Stack(
  children: [
  Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  DrawerItem(title: lang.translation['main'] [Languages.selectedLanguage],
  icon: FlutterIcons.home_ant,
                    inkWell: () {}),
                DrawerItem(
                    title: lang.translation['setting']
                        [Languages.selectedLanguage],
                    icon: FlutterIcons.settings_oct,
                    inkWell: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => ProfileScreen(
                          isService: true,
                        ),
                      ));
                    }),
                if (UserProvider.token != null)
                  DrawerItem(
                      title: lang.translation['myService']
                          [Languages.selectedLanguage],
                      icon: FlutterIcons.customerservice_ant,
                      inkWell: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => MyServiceScreen(),
                        ));
                      }),
                DrawerItem(
                    title: lang.translation['myFavService']
                        [Languages.selectedLanguage],
                    icon: FlutterIcons.favorite_border_mdi,
                    inkWell: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => FavServiceScreen(),
                      ));
                    }),
              ],
            ),
            // Positioned(
            //     top: 70,
            //     left: 70,
            //     child: Column(
            //       children: [
            //         GifImage(
            //           controller: controller,
            //           height: 70,
            //           width: 70,
            //           image: AssetImage("assets/images/drawerLogo.gif"),
            //         ),
            //         Text(
            //           lang.translation['tawfer'][Languages.selectedLanguage],
            //           style: Theme.of(context).textTheme.headline3,
            //         )
            //       ],
            //     )),
          ],
        ),
      ),
    );}}