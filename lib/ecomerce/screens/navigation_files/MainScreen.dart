import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:new_sahla/ecomerce/helpers/ecommerce_icons_icons.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/providers/UserProvider.dart';
import 'package:new_sahla/ecomerce/screens/navigation_files/searchScreen.dart';
import 'package:new_sahla/ecomerce/widgets/OrderHistoryScreen.dart';
import 'package:new_sahla/services/screens/happy_client_center.dart';
import 'package:provider/provider.dart';

import '../../../start_screen.dart';
import '../CategoriesScreen.dart';
import 'HomeScreen.dart';

class MainScreen extends StatefulWidget {
  MainScreen();

  static const routeName = '/main_Screen';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController _controller;

  int selectedIndex = 0;

  bool _hideNavBar;

  @override
  void initState() {
    super.initState();
    // SharedPreferences.getInstance().then((value) {
    //   print("this is the vaue : ${value.getInt("language")}");
    // });
    final allPro = Provider.of<AllProviders>(context, listen: false);
    allPro.getCartItems();
    selectedIndex = Languages.selectedLanguage == 1 ? 0 : 4;
    _controller =
        PageController(initialPage: Languages.selectedLanguage == 1 ? 0 : 4);
    // OneSignal.shared.setNotificationReceivedHandler((notification) {
    //   String data = notification.payload.additionalData['id'].toString();
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => PressedProduct(
    //           isMain: true,
    //         ),
    //       ));
    //   print("this is the data and the payload for the notification : $data");
    // });
  }

  List<Widget> _buildScreens() {
    if (Languages.selectedLanguage == 0) {
      return [
        CategoriesScreen(),
        // ProfileScreen(controller: _controller),
        // CartScreen(controller: _controller),
        OrderHistoryScreen(controller: _controller),
        SearchScreen(),
        HappyClientCenter(),
        HomeScreen(controller: _controller),
      ];
    } else {
      return [
        HomeScreen(controller: _controller),
        HappyClientCenter(),
        SearchScreen(),
        OrderHistoryScreen(controller: _controller),
        // CartScreen(controller: _controller),
        // ProfileScreen(controller: _controller),
        CategoriesScreen(),
      ];
    }
  }

  List<BottomNavigationBarItem> _navBarsItems() {
    if (Languages.selectedLanguage == 0) {
      return [
        BottomNavigationBarItem(
          // translucencyPercentage: 85,
          icon: Icon(CupertinoIcons.arrow_uturn_left),
          title: Text(
            Languages.selectedLanguage == 0 ? 'الرئيسية' : "Main",
            style: Theme.of(context).textTheme.headline1,
          ),
          // activeColor: Theme.of(context).primaryColor,
          // inactiveColor: Colors.grey,
          // isTranslucent: true,
        ),
        BottomNavigationBarItem(
          icon: Consumer<AllProviders>(
            builder: (ctx, allpr, _) {
              if (allpr.ordersCoun != 0) {
                return Badge(
                  animationType: BadgeAnimationType.scale,
                  badgeColor: Theme.of(context).primaryColor,
                  animationDuration: Duration(milliseconds: 100),
                  badgeContent: Container(
                    //padding: EdgeInsets.only(top: 5),
                    child: Text(
                      allpr.ordersCoun != 0 ? allpr.ordersCoun.toString() : 0,
                      style: TextStyle(color: Colors.white, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  position: BadgePosition.topStart(),
                  child: Icon(EcommerceIcons.invoice),
                );
              } else {
                return Icon(EcommerceIcons.invoice);
              }
            },
          ),
          title: Text(Languages.selectedLanguage == 0 ? 'طلباتي' : "My Orders",
              style: Theme.of(context).textTheme.headline1),
        ),
        BottomNavigationBarItem(
          icon: Icon(EcommerceIcons.magnifying_glass),
          title: Text(Languages.selectedLanguage == 0 ? 'بحث' : "search",
              style: Theme.of(context).textTheme.headline1),
        ),
        BottomNavigationBarItem(
          // translucencyPercentage: 85,
          icon: Icon(CupertinoIcons.headphones),
          title: Text(Languages.selectedLanguage == 0 ? 'مساعدة' : "help",
              style: Theme.of(context).textTheme.headline1),
          // activeColor: Theme.of(context).primaryColor,
          // inactiveColor: Colors.grey,
          // isTranslucent: true,
        ),
        BottomNavigationBarItem(
          // translucencyPercentage: 85,
          icon: Icon(EcommerceIcons.shop),
          title: Text(Languages.selectedLanguage == 0 ? 'محل' : "Shop",
              style: Theme.of(context).textTheme.headline1),
          // activeColor: Theme.of(context).primaryColor,
          // inactiveColor: Colors.grey,
          // isTranslucent: true,
        ),
      ];
    } else {
      return [
        BottomNavigationBarItem(
            // translucencyPercentage: 85,
            icon: Icon(EcommerceIcons.shop),
            title: Text(Languages.selectedLanguage == 0 ? 'محل' : "Shop",
                style: Theme.of(context).textTheme.headline1)
            // activeColor: Theme.of(context).primaryColor,
            // inactiveColor: Colors.grey,
            // isTranslucent: true,
            ),
        BottomNavigationBarItem(
          // translucencyPercentage: 85,
          icon: Icon(CupertinoIcons.headphones),
          title: Text(Languages.selectedLanguage == 0 ? 'مساعدة' : "help",
              style: Theme.of(context).textTheme.headline1),
          // activeColor: Theme.of(context).primaryColor,
          // inactiveColor: Colors.grey,
          // isTranslucent: true,
        ),
        BottomNavigationBarItem(
          // translucencyPercentage: 85,
          icon: Icon(EcommerceIcons.magnifying_glass),
          title: Text(Languages.selectedLanguage == 0 ? 'بحث' : "search",
              style: Theme.of(context).textTheme.headline1),
          // activeColor: Theme.of(context).primaryColor,
          // inactiveColor: Colors.grey,
          // isTranslucent: true,
        ),
        BottomNavigationBarItem(
          icon: Consumer<AllProviders>(
            builder: (ctx, allpr, _) {
              if (allpr.ordersCoun != 0) {
                return Badge(
                  animationType: BadgeAnimationType.scale,
                  badgeColor: Theme.of(context).primaryColor,
                  animationDuration: Duration(milliseconds: 100),
                  badgeContent: Container(
                    //padding: EdgeInsets.only(top: 5),
                    child: Text(
                      allpr.ordersCoun != 0 ? allpr.ordersCoun.toString() : 0,
                      style: TextStyle(color: Colors.white, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  position: BadgePosition.topStart(),
                  child: Icon(EcommerceIcons.invoice),
                );
              } else {
                return Icon(EcommerceIcons.invoice);
              }
            },
          ),
          title: Text(Languages.selectedLanguage == 0 ? 'طلباتي' : "My Orders",
              style: Theme.of(context).textTheme.headline1),
        ),
        BottomNavigationBarItem(
          // translucencyPercentage: 85,
          icon: Icon(CupertinoIcons.arrow_uturn_left),
          title: Text(Languages.selectedLanguage == 0 ? 'الرئيسية' : "Main",
              style: Theme.of(context).textTheme.headline1),
          // activeColor: Theme.of(context).primaryColor,
          // inactiveColor: Colors.grey,
          // isTranslucent: true,
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final allPro = Provider.of<AllProviders>(context, listen: false);
    Provider.of<Languages>(context, listen: false).readLanguageIndex();
    return WillPopScope(
      onWillPop: () async {
        UserProvider.points = UserProvider.newPoints;
        return await buildShowCupertinoDialog(context);
      },
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          backgroundColor: Colors.white,
          showUnselectedLabels: true,
          onTap: onItemTapped,
          selectedLabelStyle:
              TextStyle(color: Colors.black, fontSize: 17, fontFamily: fonts),
          unselectedLabelStyle:
              TextStyle(color: Colors.grey, fontSize: 14, fontFamily: fonts),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedIconTheme: IconThemeData(
            color: Colors.grey,
          ),
          items: _navBarsItems(),
        ),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          children: _buildScreens(),
          pageSnapping: false,
          reverse: false,
          controller: _controller,
          onPageChanged: (value) => onPageChanged(value, allPro),
        ),
        // floatingActionButtonLocation:Languages.selectedLanguage==0?
        // FloatingActionButtonLocation.miniStartDocked:FloatingActionButtonLocation.endDocked,
        // floatingActionButton:
      ),
    );
  }

  void onPageChanged(int s, allPro) {
    //  if(Languages.selectedLanguage == 0 &&s==0){
    //    // buildShowCupertinoDialog(context);
    //  }
    // else if(Languages.selectedLanguage == 1 &&s==4) {
    //    // buildShowCupertinoDialog(context);}
    //  }
    //  else
    UserProvider.points = UserProvider.newPoints;
    {
      setState(() {
        this.selectedIndex = s;
      });
      setState(() {
        if (Languages.selectedLanguage == 0 && s == 1) {
          allPro.getCartItems();
          print("pressed cart");
          return;
        } else if (Languages.selectedLanguage == 1 && s == 3) {
          print("pressed cart");
          allPro.getCartItems();
          return;
        }
        if (s == 2) {
          AllProviders.loadedAllsearchProducts = [];
          allPro.searchResult();
        }
        // allPro.dataOfflineAllProducts = null;
      }); // This is required to update the nav bar if Android back button is pressed
    }
  }

  void onItemTapped(int index) {
    if (Languages.selectedLanguage == 0 && index == 0) {
      buildShowCupertinoDialog(context);
    } else if (Languages.selectedLanguage == 1 && index == 4) {
      buildShowCupertinoDialog(context);
    } else {
      setState(() {
        this._controller.jumpToPage(
              index,
            );
      });
    }
  }

  Future<bool> buildShowCupertinoDialog(BuildContext context) {
    var dir =
        Languages.selectedLanguage == 0 ? TextDirection.rtl : TextDirection.ltr;
    return showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => CupertinoAlertDialog(
        insetAnimationCurve: Curves.easeInOutBack,
        content: Text(
          Languages.selectedLanguage == 0
              ? 'العودة إلى الرئيسية؟'
              : 'back to main?',
          textDirection: dir,
          style: Theme.of(context).textTheme.headline3,
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
            },
            child: Text(
              Languages.selectedLanguage == 0 ? 'لا' : 'no',
              textDirection: dir,
              style: TextStyle(
                  color: Colors.blue, fontFamily: fonts, fontSize: 16),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  CupertinoPageRoute(
                    builder: (context) => StartScreen(),
                  ),
                  (route) => false);
            },
            child: Text(
              Languages.selectedLanguage == 0 ? 'خروج' : 'Exit',
              textDirection: dir,
              style:
                  TextStyle(color: Colors.red, fontFamily: fonts, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
