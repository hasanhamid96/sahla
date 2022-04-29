import 'dart:io';
import 'package:animate_icons/animate_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cmoon_icons/flutter_cmoon_icons.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:new_sahla/ecomerce/screens/drawer_files/CartScreen.dart';
import 'package:new_sahla/services/helpers/toast_gf.dart';
import 'package:new_sahla/services/model/Social.dart';
import 'package:new_sahla/services/screens/fav_service_screen.dart';
import 'package:new_sahla/services/templetes/drawer_item.dart';
import 'package:new_sahla/services/widgets/terms_and_conditions.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ecomerce/helpers/app_themes.dart';
import 'ecomerce/helpers/ecommerce_icons_icons.dart';
import 'ecomerce/providers/Languages.dart';
import 'ecomerce/providers/RepositoryServiceTodo.dart';
import 'ecomerce/providers/ThemeManager.dart';
import 'ecomerce/providers/UserProvider.dart';
import 'ecomerce/providers/AllProviders.dart';
import 'ecomerce/screens/AboutUsScreen.dart';
import 'ecomerce/screens/FavoriteScreenProduct.dart';
import 'ecomerce/screens/LanguagesScreen.dart';
import 'ecomerce/screens/ProfileScreen.dart';
import 'ecomerce/widgets/ProfileThreePage.dart';

class Drawers extends StatefulWidget {
  bool isService;

  Drawers({Key key, this.isService: false}) : super(key: key);

  @override
  State<Drawers> createState() => _DrawersState();
}

class _DrawersState extends State<Drawers> {
  Social social = Social(
    share: '2',
    youtube: '2',
    whatsApp2: '2',
    whatsApp1: '2',
    massenger: '2',
    instagram: '2',
    twitter: '2',
    id: '2',
    faceBook: '2',
    webSite: '2',
  );

  AnimateIconController controller;

  bool isDark = false;

  bool isLoadingSocial = true;

  Future<void> openInstagram() async {
    String openInstagram = 'https://${social.instagram}';
    if (await canLaunch(openInstagram)) {
      await launch(openInstagram).catchError((onError) {
        ToastGF.showError(context, "Could not launch Instagram");
      });
    } else {
      ToastGF.showError(
          context,
          Languages.selectedLanguage == 0
              ? "لا يمكن فتح Instagram أو عدم التثبيت"
              : "can not open Instagram or not install");
      throw "can not open Instagram or not install";
    }
  }

  Future<String> whatsApp() async {
    var url;
    if (Platform.isAndroid) {
      url = "https://wa.me/964${social.whatsApp1}/?text="; // new line
    } else {
      url = "https://api.whatsapp.com/send?phone=964${social.whatsApp1}";
    }
    try {
      await launch(url).catchError((er) {
        print(er);
        ToastGF.showError(context, 'Could not launch whatsApp');
      });
    } catch (e) {
      // if (await canLaunch(url)) {
      // } else {
      ToastGF.showError(context, 'Could not launch');
      // throw 'Could not launch ${whatsApp()}';
    }
  }

  Future<void> openFaceBook() async {
    String facebookUrl = 'https://${social.faceBook}';
    if (await canLaunch(facebookUrl)) {
      await launch(facebookUrl).catchError((onError) {
        ToastGF.showError(
            context,
            Languages.selectedLanguage == 0
                ? "لا يمكن فتح الفيسبوك أو عدم التثبيت"
                : "can not open facebook or not install ");
      });
    } else {
      ToastGF.showError(
          context,
          Languages.selectedLanguage == 0
              ? "لا يمكن فتح الفيسبوك أو عدم التثبيت"
              : "can not open facebook or not install");
      throw 'can not open facebook or not install';
    }
  }

  Container circleIconAppoint(BuildContext context, IconData iconData,
      Function function, Color color, Color background) {
    return Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(colors: [
              background,
              background,
            ])),
        child: IconButton(
          onPressed: function,
          icon: Icon(
            iconData,
            size: 33,
            color: color,
          ),
        ));
  }

  void getCartItemCount() async {
    print("ss");
    final count = await RepositoryServiceTodo.cartsCount();
    Provider.of<AllProviders>(context, listen: false).refreshCartItem(count);
  }

  Widget buildDrawer(context) {
    final lang = Provider.of<Languages>(context);
    final allPro = Provider.of<AllProviders>(context, listen: false);
    return Container(
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              DrawerItem(
                  title: lang.translation['LanguageTitle']
                      [Languages.selectedLanguage],
                  icon: FlutterIcons.language_ent,
                  inkWell: () {
                    Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => LanguagesScreen(),
                    ));
                  }),
              DrawerItem(
                  title: widget.isService
                      ? lang.translation['myFavService']
                          [Languages.selectedLanguage]
                      : lang.translation['FavoriteProd']
                          [Languages.selectedLanguage],
                  icon: FlutterIcons.favorite_border_mdi,
                  inkWell: () {
                    if (!widget.isService) {
                      allPro.isFavoriteOk = false;
                      allPro.getFavoriteOnce = false;
                      allPro.getAllfavorite();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FavoriteScreen(),
                          ));
                    } else
                      Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => FavServiceScreen(),
                      ));
                  }),
              DrawerItem(
                  title: lang.translation['cartTitle']
                      [Languages.selectedLanguage],
                  isCart: true,
                  icon: EcommerceIcons.shopping_cart,
                  inkWell: () {
                    final allPro =
                        Provider.of<AllProviders>(context, listen: false);
                    allPro.getCartItems();
                    Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => CartScreen(),
                    ));
                  }),
              DrawerItem(
                  title: lang.translation['howWe'][Languages.selectedLanguage],
                  icon: Icons.quick_contacts_dialer_outlined,
                  inkWell: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AboutUsScreen(),
                        ));
                  }),
              DrawerItem(
                  title: lang.translation['termAndCondition']
                      [Languages.selectedLanguage],
                  icon: Icons.bookmarks,
                  inkWell: () {
                    Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => TermsAndConditions(),
                    ));
                  }),
              if (UserProvider.isLogin)
                DrawerItem(
                    title: lang.translation['myPoints']
                        [Languages.selectedLanguage],
                    icon: Icons.local_offer_outlined,
                    isPoints: true),
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
    );
  }

  bool darkTheme = false;
  int preferredTheme;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final allPro = Provider.of<AllProviders>(context, listen: false);
    final userPro = Provider.of<UserProvider>(context, listen: false);
    allPro.getCartItems();
    if (userPro.getOnceProfile) userPro.getProfile();
    getCartItemCount();
    SharedPreferences.getInstance().then((prefs) {
      preferredTheme = prefs.getInt("theme_preference") ?? 0;
      setState(() {
        if (preferredTheme == 0) {
          print('not dark');
          isDark = false;
        } else {
          isDark = true;
          print('is dark');
        }
      });
    });
    controller = AnimateIconController();
    var media = Provider.of<AllProviders>(context, listen: false);
    media.fetchDataInfo().then((value) {
      social = Social(
        share: media.share,
        youtube: media.youtube,
        whatsApp2: '2',
        whatsApp1: media.whatsup,
        massenger: '2',
        instagram: media.insta,
        twitter: media.twitter,
        id: '2',
        faceBook: media.facebook,
        webSite: '2',
      );
      isLoadingSocial = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var dir =
        Languages.selectedLanguage == 0 ? TextDirection.rtl : TextDirection.ltr;
    final mediaQuery = MediaQuery.of(context).size;
    return Drawer(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: mediaQuery.width * 0.9,
              decoration: BoxDecoration(
                  // color: Theme.of(context).appBarTheme.color,
                  gradient: LinearGradient(
                      colors: [
                    Theme.of(context).appBarTheme.color,
                    Theme.of(context).appBarTheme.color.withOpacity(0.7),
                  ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      tileMode: TileMode.clamp)),
              child: DrawerHeader(
                child: Container(
                  alignment: Languages.selectedLanguage == 0
                      ? Alignment.topRight
                      : Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: Languages.selectedLanguage == 0
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              if (UserProvider.isLogin) {
                                Navigator.pop(
                                  context,
                                );
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => ProfileThreePage(),
                                    ));
                              }
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.grey[400],
                              radius: mediaQuery.width * 0.13,
                              backgroundImage: UserProvider.isLogin == false
                                  ? null
                                  : CachedNetworkImageProvider(
                                      '${UserProvider.userImage}',
                                      errorListener: () => null,
                                    ),
                              child: UserProvider.isLogin == false
                                  ? Icon(
                                      EcommerceIcons.user,
                                      size: 50,
                                      color: Theme.of(context).canvasColor,
                                    )
                                  : null,
                            ),
                          ),
                          AnimateIcons(
                            startIcon: Icons.brightness_2,
                            endIcon: Icons.wb_sunny,
                            size: 25.0,
                            controller: controller,
                            // add this tooltip for the start icon
                            startTooltip: 'change to dark light',
                            // add this tooltip for the end icon
                            endTooltip: 'change to dark theme',
                            onStartIconPress: () {
                              AppTheme theme;
                              if (isDark != true) {
                                theme = AppTheme.values[1];
                              } else {
                                theme = AppTheme.values[0];
                              }
                              setState(() {
                                darkTheme = isDark;
                                isDark = !isDark;
                                Provider.of<ThemeManager>(context,
                                        listen: false)
                                    .setTheme(theme);
                              });
                              print("Clicked on Add Icon");
                              return true;
                            },
                            onEndIconPress: () {
                              AppTheme theme;
                              if (isDark != true) {
                                theme = AppTheme.values[1];
                              } else {
                                theme = AppTheme.values[0];
                              }
                              setState(() {
                                isDark = !isDark;
                                darkTheme = isDark;
                                Provider.of<ThemeManager>(context,
                                        listen: false)
                                    .setTheme(theme);
                              });
                              print("Clicked on Close Icon");
                              return true;
                            },
                            duration: Duration(milliseconds: 500),
                            startIconColor: Colors.black,
                            endIconColor: Colors.white,
                            clockwise: true,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        alignment: Languages.selectedLanguage == 0
                            ? Alignment.topRight
                            : Alignment.topLeft,
                        child: Padding(
                            padding: EdgeInsets.only(left: 26, right: 26),
                            child: Text(
                              '${UserProvider.isLogin ? UserProvider.userName : 'Guest'}',
                              textAlign: UserProvider.isLogin
                                  ? null
                                  : TextAlign.center,
                              style: Theme.of(context).textTheme.headline3,
                              textDirection: dir,
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [buildDrawer(context)],
                ),
              ),
            )
          ],
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(),
            if (isLoadingSocial)
              Row(
                children: [
                  for (int i = 0; i < 4; i++)
                    Shimmer.fromColors(
                      baseColor: Colors.black87,
                      highlightColor: Colors.white,
                      period: Duration(milliseconds: 700),
                      child: circleIconAppoint(
                        context,
                        IconMoon.icon_facebook,
                        openFaceBook,
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.1),
                      ),
                    ),
                ],
              ),
            if (!isLoadingSocial)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  circleIconAppoint(context, IconMoon.icon_facebook,
                      openFaceBook, Colors.white, Colors.blue),
                  circleIconAppoint(context, IconMoon.icon_whatsapp, whatsApp,
                      Colors.white, Colors.green),
                  circleIconAppoint(context, IconMoon.icon_instagram,
                      openInstagram, Colors.white, Colors.pink),
                  circleIconAppoint(
                    context,
                    IconMoon.icon_share1,
                    () async {
                      await Share.share('${social.share}', subject: 'share');
                    },
                    Colors.white,
                    Colors.black,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
