import 'package:badges/badges.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/helpers/ecommerce_icons_icons.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/providers/RepositoryServiceTodo.dart';
import 'package:new_sahla/ecomerce/providers/UserProvider.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/ecomerce/widgets/ProfileThreePage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../start_screen.dart';
import 'AddressesScreen.dart';
import 'FavoriteScreenProduct.dart';
import 'LoginScreen.dart';

class ProfileScreen extends StatefulWidget {
  final PageController controller;
  bool isService;

  ProfileScreen({this.controller, this.isService: false});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool notification = true;

  bool darkTheme = false;

  int preferredTheme;

  bool isLoad = true;

  @override
  void initState() {
    // TODO: implement initState
    Provider.of<UserProvider>(context, listen: false)
        .getProfile()
        .then((value) {
      setState(() {
        isLoad = false;
      });
    });
    SharedPreferences.getInstance().then((prefs) {
      preferredTheme = prefs.getInt("theme_preference") ?? 0;
      if (preferredTheme == 0) {
        darkTheme = false;
      } else {
        darkTheme = true;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final allPro = Provider.of<AllProviders>(context, listen: false);
    final userPro = Provider.of<UserProvider>(context, listen: false);
    final lang = Provider.of<Languages>(context, listen: false);
    var dir =
        Languages.selectedLanguage == 0 ? TextDirection.rtl : TextDirection.ltr;
    return Directionality(
      textDirection: dir,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),
            ),
          ],
          title: Text(
            lang.translation['SettingsTitle'][Languages.selectedLanguage],
            textAlign: TextAlign.right,
            style:
                TextStyle(fontSize: 20, fontFamily: fonts, color: Colors.white),
          ),
        ),
        body: isLoad
            ? buildCenter()
            : SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      UserProvider.isLogin == true
                          ? Container(
                              margin: EdgeInsets.only(top: 10),
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              child: SettingTemplate(
                                icon: EcommerceIcons.user,
                                title: UserProvider.userName,
                                lastWidget: Icon(
                                  Languages.selectedLanguage == 0
                                      ? Icons.keyboard_arrow_left
                                      : Icons.keyboard_arrow_right,
                                  color: Theme.of(context).bottomAppBarColor,
                                ),
                                notiNumber: 0,
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) =>
                                            ProfileThreePage(),
                                      ));
                                },
                              ))
                          : SizedBox(),
                      UserProvider.isLogin == false
                          ? SettingTemplate(
                              icon: Icons.account_box,
                              title: lang.translation['SignIn']
                                  [Languages.selectedLanguage],
                              lastWidget: Icon(
                                Languages.selectedLanguage == 0
                                    ? Icons.keyboard_arrow_left
                                    : Icons.keyboard_arrow_right,
                                color: Theme.of(context).bottomAppBarColor,
                              ),
                              notiNumber: 0,
                              onTap: () {
                                setState(() {
                                  allPro.NavBarShow(false);
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginScreen(),
                                    ));
                              },
                            )
                          : SizedBox(),
                      Divider(
                        height: 0,
                        color: Theme.of(context)
                            .bottomAppBarColor
                            .withOpacity(0.3),
                      ),
                      UserProvider.isLogin == true
                          ? Container(
                              margin: EdgeInsets.only(
                                  right: 25, top: 15, bottom: 15, left: 25),
                              alignment: Languages.selectedLanguage == 0
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Text(
                                lang.translation['accountTitle']
                                    [Languages.selectedLanguage],
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: fonts,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).bottomAppBarColor,
                                ),
                              ),
                            )
                          : SizedBox(),
                      if (UserProvider.isLogin && !widget.isService)
                        SettingTemplate(
                          title: lang.translation['FavoriteTitle']
                              [Languages.selectedLanguage],
                          onTap: () {
                            setState(() {
                              // allPro.NavBarShow(false);
                            });
                            allPro.isFavoriteOk = false;
                            allPro.getFavoriteOnce = false;
                            allPro.getAllfavorite();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FavoriteScreen(),
                                ));
                          },
                          lastWidget: Icon(
                            Languages.selectedLanguage == 0
                                ? Icons.keyboard_arrow_left
                                : Icons.keyboard_arrow_right,
                            color: Theme.of(context).bottomAppBarColor,
                          ),
                          icon: Icons.favorite,
                          notiNumber: allPro.allFavoriteItems.length == 0
                              ? 0
                              : allPro.allFavoriteItems.length,
                        ),
                      UserProvider.isLogin == true
                          ? Divider(
                              height: 0,
                              color: Theme.of(context)
                                  .bottomAppBarColor
                                  .withOpacity(0.3),
                            )
                          : SizedBox(),
                      // UserProvider.isLogin == true
                      //     ? SettingTemplate(
                      //         title: lang.translation['OrdersTitle']
                      //             [Languages.selectedLanguage],
                      //         lastWidget: Icon(
                      //           Languages.selectedLanguage == 0
                      //               ? Icons.keyboard_arrow_left
                      //               : Icons.keyboard_arrow_right,
                      //           color: Theme.of(context).bottomAppBarColor,
                      //         ),
                      //         icon: EcommerceIcons.shopping_cart,
                      //         notiNumber: allPro.ordersCoun != 0
                      //             ? allPro.ordersCoun
                      //             : 0,
                      //         onTap: () {
                      //           // allPro.getOrders();
                      //           Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                 builder: (context) =>
                      //                     OrderHistoryScreen(),
                      //               ));
                      //         },
                      //       )
                      //     : SizedBox(),
                      UserProvider.isLogin == true
                          ? Divider(
                              height: 0,
                              color: Theme.of(context)
                                  .bottomAppBarColor
                                  .withOpacity(0.3),
                            )
                          : SizedBox(),
                      //add adderss
                      UserProvider.isLogin == true
                          ? SettingTemplate(
                              title: Languages.selectedLanguage == 0
                                  ? 'عنواني'
                                  : 'my address',
                              onTap: () {
                                RepositoryServiceTodo.getAllAddress(
                                        allpro: allPro)
                                    .then((value) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddressesScreen(),
                                      ));
                                });
                              },
                              lastWidget: Icon(
                                Languages.selectedLanguage == 0
                                    ? Icons.keyboard_arrow_left
                                    : Icons.keyboard_arrow_right,
                                color: Theme.of(context).bottomAppBarColor,
                              ),
                              icon: EcommerceIcons.map,
                              notiNumber: allPro.allFavoriteItems.length == 0
                                  ? 0
                                  : allPro.allFavoriteItems.length,
                            )
                          : SizedBox(),
                      UserProvider.isLogin == true
                          ? Divider(
                              height: 0,
                              color: Theme.of(context)
                                  .bottomAppBarColor
                                  .withOpacity(0.3),
                            )
                          : SizedBox(),
                      Container(
                        margin: EdgeInsets.only(
                            right: 25, top: 15, bottom: 15, left: 25),
                        alignment: Languages.selectedLanguage == 0
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Text(
                          lang.translation['MainSettings']
                              [Languages.selectedLanguage],
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: fonts,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).bottomAppBarColor,
                          ),
                        ),
                      ),
                      SettingTemplate(
                        title: lang.translation['notification']
                            [Languages.selectedLanguage],
                        lastWidget: Switch.adaptive(
                          value: notification,
                          activeColor: Theme.of(context).primaryColor,
                          onChanged: (value) {
                            setState(() {
                              notification = value;
                            });
                          },
                        ),
                        icon: Icons.notifications,
                        notiNumber: 0,
                      ),
                      UserProvider.isLogin == true
                          ? SettingTemplate(
                              title: lang.translation['signOut']
                                  [Languages.selectedLanguage],
                              lastWidget: Icon(
                                Languages.selectedLanguage == 0
                                    ? Icons.keyboard_arrow_left
                                    : Icons.keyboard_arrow_right,
                                color: Theme.of(context).bottomAppBarColor,
                              ),
                              icon: Icons.logout,
                              notiNumber: 0,
                              onTap: () {
                                buildShowCupertinoDialog(
                                    context, userPro, widget.controller);
                              },
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

Future<bool> buildShowCupertinoDialog(
    BuildContext context, userPro, controller) {
  var dir =
      Languages.selectedLanguage == 0 ? TextDirection.rtl : TextDirection.ltr;
  return showCupertinoDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => CupertinoAlertDialog(
      insetAnimationCurve: Curves.easeInOutBack,
      content: Text(
        Languages.selectedLanguage == 0
            ? 'هل ترغب بالخروج؟'
            : 'do you want to LogOut?',
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
            style:
                TextStyle(color: Colors.blue, fontFamily: fonts, fontSize: 16),
          ),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            userPro.signOut(controller);
            Navigator.of(context).pop();
            Navigator.of(context).pushAndRemoveUntil(
                CupertinoPageRoute(
                  builder: (context) => StartScreen(),
                ),
                (route) => false);
          },
          child: Text(
            Languages.selectedLanguage == 0 ? 'تسجيل خروج' : 'LogOut',
            textDirection: dir,
            style:
                TextStyle(color: Colors.red, fontFamily: fonts, fontSize: 16),
          ),
        ),
      ],
    ),
  );
}

Center buildCenter() {
  return Center(
    child: Shimmer.fromColors(
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.all(0),
              tileColor: Colors.white.withOpacity(0.1),
            ),
            Padding(
              padding: const EdgeInsets.all(1),
              child: Divider(
                color: Colors.white.withOpacity(0.1),
                height: 0,
              ),
            )
          ],
        ),
      ),
      baseColor: Colors.black87,
      period: Duration(milliseconds: 700),
      highlightColor: Colors.white,
    ),
  );
}

class SettingTemplate extends StatelessWidget {
  final String title;
  final int notiNumber;
  final IconData icon;
  final Widget lastWidget;
  final Function onTap;

  SettingTemplate({
    this.title,
    this.notiNumber,
    this.icon,
    this.lastWidget,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<Languages>(context);
    var dir =
        Languages.selectedLanguage == 0 ? TextDirection.rtl : TextDirection.ltr;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    if (icon == Icons.notifications)
                      CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/placeholder.png'))
                    else
                      Icon(
                        icon,
                        color: Theme.of(context).bottomAppBarColor,
                        size: icon == Icons.notifications ? 25 : 22,
                      ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(4),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        title,
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: fonts,
                            fontWeight: title ==
                                    lang.translation['signOut']
                                        [Languages.selectedLanguage]
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: Theme.of(context).bottomAppBarColor),
                      ),
                    ),
                    notiNumber != 0
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Badge(
                              shape: BadgeShape.circle,
                              animationType: BadgeAnimationType.slide,
                              badgeColor: Theme.of(context).primaryColor,
                              animationDuration: Duration(milliseconds: 100),
                              badgeContent: Container(
                                  // padding: EdgeInsets.only(top: 5),
                                  child: Text(
                                notiNumber.toString(),
                                style: TextStyle(
                                    fontFamily: fonts,
                                    color: Colors.white,
                                    fontSize: 12),
                                textAlign: TextAlign.center,
                              )),
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: 20),
                  child: lastWidget,
                ),
                flex: 0,
              ),
            ]),
      ),
    );
  }
}
