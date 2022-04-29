import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:blur/blur.dart';

//
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/providers/UserProvider.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/ecomerce/screens/LoginScreen.dart';
import 'package:new_sahla/services/model/Service.dart';
import 'package:new_sahla/services/providers/DBHelper.dart';
import 'package:new_sahla/services/providers/Orders.dart';
import 'package:new_sahla/services/providers/Services.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

import 'fav_service_screen.dart';
import 'map_screen.dart';

class DetailService extends StatefulWidget {
  Service service;
  bool isMyService;
  int servceId;

  DetailService({Key key, this.service, this.isMyService: false, this.servceId})
      : super(key: key);

  @override
  State<DetailService> createState() => _DetailServiceState();
}

class _DetailServiceState extends State<DetailService>
    with TickerProviderStateMixin {
  AnimationController animationController;
  Service service;
  Animation<double> animation;

  bool isLoad = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dirr();
    isAddToFav = false;
    if (widget.servceId != null) {
      print('fetch single ${widget.servceId}');
      setState(() {
        isLoad = true;
      });
      Provider.of<Services>(context, listen: false)
          .fetchSingleService(SecId: widget.servceId)
          .then((value) {
        setState(() {
          service = value;
          isLoad = false;
        });
      });
    } else {
      service = widget.service;
    }
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.ease,
    );
    Future.delayed(Duration(milliseconds: 400))
        .then((value) => animationController.forward());
    Provider.of<Services>(context, listen: false).getfav();
  }

  bool favLoad = true;

  Future<bool> favChecker() async {
    List<Service> favlist =
        Provider.of<Services>(context, listen: false).favService;
    print(favlist);
    if (favlist.length != 0 && favlist != null && favlist != [])
      favlist.forEach((element) {
        if (element.id == widget.service.id) {
          setState(() {
            isAddToFav = true;
          });
        }
        // else {
        //   isAddToFav = false;
        //
        // }
      });
    return isAddToFav;
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    setState(() {
      favLoad = true;
    });
    favChecker().then((value) {
      setState(() {
        favLoad = false;
      });
    });
  }

  var columnDir;

  var rowDir;

  var textDir;

  void dirr() {
    if (Languages.selectedLanguage == 0) {
      textDir = ui.TextDirection.rtl;
      columnDir = CrossAxisAlignment.end;
      rowDir = MainAxisAlignment.end;
    } else {
      textDir = ui.TextDirection.ltr;
      columnDir = CrossAxisAlignment.start;
      rowDir = MainAxisAlignment.start;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final lang = Provider.of<Languages>(context);
    final allPro = Provider.of<AllProviders>(context);
    return isLoad
        ? Container(
            color: Colors.white,
            child: Center(
                child: CircularProgressIndicator.adaptive(
              backgroundColor: Colors.lightBlue,
            )))
        : Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              elevation: 0,
              leadingWidth: 200,
              backgroundColor: Colors.transparent,
              leading: Row(
                children: [
                  FloatingActionButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    mini: true,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    heroTag: '1',
                    backgroundColor: Colors.white54,
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 0, top: 0),
                    child: FloatingActionButton(
                      isExtended: false,
                      heroTag: '2',
                      mini: true,
                      elevation: 0,
                      backgroundColor: Colors.white54,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 3.0, top: 3),
                        child: LikeButton(
                          onTap: (isLiked) async {
                            List<Service> favlist =
                                Provider.of<Services>(context, listen: false)
                                    .favService;
                            if (isAddToFav) {
                              favlist.removeWhere(
                                  (element) => element.id == widget.service.id);
                              await DBHelper.delete(
                                'serviceFav',
                                widget.service.id.toString(),
                              ).then((value) {
                                showSnackBar(context, '');
                              });
                            } else
                              await DBHelper.insert('serviceFav', {
                                'id': widget.service.id,
                                'name': widget.service.name,
                                'desc': widget.service.description,
                                'image': widget.service.image,
                                'price': widget.service.price,
                              }).then((value) {
                                showSnackBar(context, null);
                                favlist.add(widget.service);
                              });
                            setState(() {
                              isAddToFav = !isLiked;
                            });
                            return !isLiked;
                          },
                          circleColor: CircleColor(
                              start: Theme.of(context).primaryColor,
                              end: Theme.of(context).primaryColor),
                          bubblesColor: BubblesColor(
                            dotPrimaryColor: Theme.of(context).primaryColor,
                            dotSecondaryColor: Theme.of(context).primaryColor,
                          ),
                          isLiked: isAddToFav,
                          likeBuilder: (bool isLiked) {
                            return Icon(
                              Icons.favorite,
                              color: isAddToFav
                                  ? Theme.of(context).primaryColor
                                  : Colors.white.withOpacity(0.9),
                              size: 25,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: favLoad
                ? Center(child: CircularProgressIndicator.adaptive())
                : Material(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Stack(
                            overflow: Overflow.visible,
                            children: [
                              //blur image
                              ImageBlur.network(
                                '${widget.service.image}',
                                fit: BoxFit.cover,
                                scale: 1,
                                blurColor: Colors.black45.withOpacity(0.5),
                                colorOpacity: 0.3,
                                height: mediaQuery.height * 0.3,
                                width: double.infinity,
                                blur: 1.9,
                              ),
                              //shadow
                              Positioned(
                                bottom: -35,
                                right: 20,
                                child: Container(
                                  height: mediaQuery.height * 0.01,
                                  width: mediaQuery.width * 0.4,
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(boxShadow: [
                                    BoxShadow(
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline3
                                            .color,
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                        offset: Offset(0, 0))
                                  ], borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                              //image
                              Positioned(
                                bottom: -20,
                                right: 20,
                                child: Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            CupertinoPageScaffold(
                                          backgroundColor: Colors.transparent,
                                          child: Stack(
                                            children: [
                                              Center(
                                                child: Image.network(
                                                  '${widget.service.image}',
                                                  scale: 1,
                                                ),
                                              ),
                                              Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: RaisedButton(
                                                  color: Colors.redAccent,
                                                  child: Text(
                                                    lang.translation['back'][
                                                        Languages
                                                            .selectedLanguage],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline3,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        '${widget.service.image}',
                                        fit: BoxFit.cover,
                                        scale: 1,
                                        height: mediaQuery.height * 0.26,
                                        width: mediaQuery.width * 0.4,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              //title
                              Positioned(
                                top: mediaQuery.height * 0.2 + 10,
                                right: mediaQuery.width * 0.4 + 20,
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          '${widget.service.name}',
                                          textDirection: ui.TextDirection.rtl,
                                          style: TextStyle(
                                              color: CupertinoColors.white,
                                              fontSize: 15,
                                              fontFamily: fonts,
                                              fontWeight: FontWeight.bold,
                                              shadows: [
                                                Shadow(
                                                  offset: Offset(0, 0),
                                                  color: Colors.white54,
                                                  blurRadius: 20,
                                                )
                                              ]),
                                        ),
                                      ],
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          //discount
                          Container(
                            width: mediaQuery.width * 1,
                            height: mediaQuery.height * 0.16,
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              color: Colors.redAccent.withOpacity(0.9),
                              child: Stack(
                                // overflow: Overflow.visible,
                                children: [
                                  Positioned(
                                      top: -20,
                                      left: 0,
                                      child: Image.asset(
                                        'assets/images/3coin.png',
                                        width: mediaQuery.width * 0.38,
                                        fit: BoxFit.cover,
                                      )),
                                  Positioned.fill(
                                    right: -60,
                                    top: -10,
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(''),
                                          Text(
                                            '${allPro.numToStringForService(widget.service.price)}  ${widget.service.inMinutes == 1 ? 'IQD/min' : 'IQD'}',
                                            textDirection: ui.TextDirection.rtl,
                                            style: TextStyle(
                                                fontFamily: 'cairo',
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      bottom: 30,
                                      left: mediaQuery.width * 0.3,
                                      right: 50,
                                      child: Divider(
                                        height: 10,
                                        color: Colors.white70,
                                      ))
                                ],
                              ),
                            ),
                          ),
                          //description
                          Container(
                            width: mediaQuery.width * 1,
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 1,
                              color: Theme.of(context).hoverColor,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: columnDir,
                                  children: [
                                    Text(
                                      lang.translation['DescriptionTitle']
                                          [Languages.selectedLanguage],
                                      style:
                                          Theme.of(context).textTheme.headline3,
                                      textDirection: textDir,
                                    ),
                                    Divider(),
                                    Text(
                                      '${widget.service.description}',
                                      style:
                                          Theme.of(context).textTheme.headline3,
                                      textDirection: textDir,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          //
                          if (widget.service.include.isNotEmpty)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Card(
                                color: Theme.of(context).hoverColor,
                                elevation: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: columnDir,
                                    children: [
                                      Text(
                                        lang.translation['include']
                                            [Languages.selectedLanguage],
                                        style: TextStyle(
                                            color: Colors.greenAccent,
                                            fontSize: 17,
                                            fontFamily: fonts),
                                        textDirection: textDir,
                                      ),
                                      Divider(),
                                      ...widget.service.include
                                          .map((e) => ListTile(
                                                trailing: Languages
                                                            .selectedLanguage ==
                                                        0
                                                    ? CircleAvatar(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        backgroundImage:
                                                            CachedNetworkImageProvider(
                                                                '${e.icon}',
                                                                maxWidth: 50,
                                                                maxHeight: 50),
                                                      )
                                                    : null,
                                                leading: Languages
                                                            .selectedLanguage ==
                                                        1
                                                    ? CircleAvatar(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        backgroundImage:
                                                            CachedNetworkImageProvider(
                                                                '${e.icon}',
                                                                maxWidth: 50,
                                                                maxHeight: 50),
                                                      )
                                                    : null,
                                                title: Container(
                                                  // width: mediaQuery.width*0.6,
                                                  child: Text(e.title,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline3,
                                                      textDirection: textDir),
                                                ),
                                                subtitle: Container(
                                                  width: mediaQuery.width * 0.8,
                                                  child: Text(e.desc,
                                                      overflow:
                                                          TextOverflow.visible,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle1,
                                                      textDirection: textDir),
                                                ),
                                              ))
                                          .toList()
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          if (widget.service.notInclude.isNotEmpty)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Card(
                                elevation: 1,
                                color: Theme.of(context).hoverColor,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: columnDir,
                                    children: [
                                      Text(
                                          lang.translation['notInclude']
                                              [Languages.selectedLanguage],
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 17,
                                              fontFamily: fonts),
                                          textDirection: textDir),
                                      Divider(),
                                      ...widget.service.notInclude
                                          .map((e) => ListTile(
                                                trailing: Languages
                                                            .selectedLanguage ==
                                                        0
                                                    ? CircleAvatar(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        backgroundImage:
                                                            CachedNetworkImageProvider(
                                                                e.icon,
                                                                maxWidth: 50,
                                                                maxHeight: 50),
                                                      )
                                                    : null,
                                                leading: Languages
                                                            .selectedLanguage ==
                                                        1
                                                    ? CircleAvatar(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        backgroundImage:
                                                            CachedNetworkImageProvider(
                                                                e.icon,
                                                                maxWidth: 50,
                                                                maxHeight: 50),
                                                      )
                                                    : null,
                                                title: Container(
                                                  // width: mediaQuery.width*0.6,
                                                  child: Text(e.title,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline3,
                                                      textDirection: textDir),
                                                ),
                                                subtitle: Container(
                                                  // width: mediaQuery.width*0.8,
                                                  child: Text(e.desc,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle1,
                                                      textDirection: textDir),
                                                ),
                                              ))
                                          .toList()
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          //add service request
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
            bottomNavigationBar: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (!widget.isMyService)
                  Expanded(
                    child: RaisedButton.icon(
                      icon: Icon(
                        CupertinoIcons.add_circled_solid,
                        color: Colors.white,
                      ),
                      color: Theme.of(context).accentColor,
                      padding: const EdgeInsets.all(10.0),
                      label: Text(
                          lang.translation['getThisService']
                              [Languages.selectedLanguage],
                          style: Theme.of(context).textTheme.headline2),
                      onPressed: () {
                        if (UserProvider.token == null)
                          showCupertinoDialog(
                            context: context,
                            builder: (context) => CupertinoAlertDialog(
                              title: Text(
                                Languages.selectedLanguage == 0
                                    ? "لم تقم بالتسجيل بعد"
                                    : 'you don\'t have registed yet',
                                style: TextStyle(
                                    color: Colors.tealAccent,
                                    fontFamily: fonts),
                              ),
                              content: Text(
                                Languages.selectedLanguage == 0
                                    ? 'سجل الان'
                                    : 'Register now',
                                style: TextStyle(
                                    color: Colors.tealAccent,
                                    fontFamily: fonts),
                              ),
                              actions: [
                                CupertinoActionSheetAction(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text(
                                      lang.translation['back']
                                          [Languages.selectedLanguage],
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontFamily: fonts),
                                    )),
                                CupertinoActionSheetAction(
                                    onPressed: () => {
                                          Navigator.of(context).pop(),
                                          Navigator.of(context)
                                              .push(CupertinoPageRoute(
                                            builder: (context) => LoginScreen(),
                                          )),
                                        },
                                    child: Text(
                                      lang.translation['SignIn']
                                          [Languages.selectedLanguage],
                                      style: TextStyle(
                                          color: Colors.red, fontFamily: fonts),
                                    ))
                              ],
                            ),
                          );
                        else
                          showCupertinoModalBottomSheet(
                              animationCurve: Curves.easeInOutBack,
                              duration: Duration(milliseconds: 700),
                              useRootNavigator: false,
                              bounce: false,
                              context: context,
                              enableDrag: true,
                              isDismissible: true,
                              builder: (context) {
                                return StatefulBuilder(
                                    builder: (context, stateFule) {
                                  return AddServiceForm(
                                    serviceId: widget.service.id,
                                    stateFule: stateFule,
                                  );
                                });
                              });
                      },
                    ),
                  ),
              ],
            ),
            // ),
          );
  }

  bool isAddToFav = false;

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
      BuildContext context, covariant) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: 800),
        action: SnackBarAction(
            onPressed: () => Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => FavServiceScreen(),
                )),
            label: Languages.selectedLanguage == 1
                ? 'go to Favorites'
                : "اذهب إلى المفضلة"),
        content: covariant == null
            ? Text(Languages.selectedLanguage == 1
                ? 'add to Favorites'
                : 'اضافة الى المفضلة')
            : Text('$covariant'),
      ),
    );
  }
}

class AddServiceForm extends StatefulWidget {
  int serviceId;
  Function stateFule;

  AddServiceForm({Key key, this.serviceId, this.stateFule}) : super(key: key);
  static String name = UserProvider.userName;
  static String phone = UserProvider.userPhone;
  static String desc;

  @override
  State<AddServiceForm> createState() => _AddServiceFormState();
}

class _AddServiceFormState extends State<AddServiceForm> {
  Set<Marker> markers = {};

  var _key = GlobalKey<FormState>();

  bool isScheduling = false;

  DateTime _selSchedule = DateTime.now();

  Future<void> schedule() {
    return showModalBottomSheet(
      isDismissible: true,
      context: context,
      enableDrag: false,
      builder: (context) => StatefulBuilder(builder: (context, setStates) {
        return Container(
          height: 300,
          width: MediaQuery.of(context).size.width,
          child: FittedBox(
            fit: BoxFit.fitHeight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  child: CupertinoDatePicker(
                    initialDateTime: DateTime.now(),
                    use24hFormat: false,
                    mode: CupertinoDatePickerMode.dateAndTime,
                    onDateTimeChanged: (value) {
                      widget.stateFule(() {
                        setStates(() {
                          _selSchedule = value;
                        });
                        print(value);
                      });
                    },
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     CupertinoActionSheetAction(
                //         isDestructiveAction: true,
                //         child: Text(Languages.selectedLanguage==1?'Back':'
                //         onPressed: () {
                //           setState(() {
                //             isScheduling = false;
                //           });
                //           Navigator.pop(context);
                //         }),
                //     SizedBox(
                //       width: 20,
                //     ),
                //     CupertinoActionSheetAction(
                //         isDefaultAction: true,
                //         child: Text(
                //           'Order',
                //           style: TextStyle(color: Colors.blue),
                //         ),
                //         onPressed: () {
                //           setState(() {
                //             isScheduling = true;
                //           });
                //           Navigator.pop(context);
                //         }),
                //   ],
                // ),
              ],
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (UserProvider.latitude != null) {
      markers = {};
      markers.clear();
      markers.add(Marker(
          position: LatLng(UserProvider.latitude, UserProvider.longitude),
          markerId: MarkerId('UserProvider.latitude'),
          icon: BitmapDescriptor.defaultMarker));
    }
    final lang = Provider.of<Languages>(context);
    return Container(
      height: MediaQuery.of(context).size.height * 0.58,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Center(
            child: Stack(
              overflow: Overflow.visible,
              children: [
                Positioned.fill(
                  top: -6,
                  child: Container(
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 60,
                      height: 4,
                      decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                ),
                Text(
                  Languages.selectedLanguage == 1
                      ? 'Apply service'
                      : 'تطبيق الخدمة',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                splashRadius: 20,
                icon: CircleAvatar(
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  backgroundColor: Theme.of(context).accentColor,
                  radius: 14,
                ),
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              children: [
                textFiled(
                    1,
                    lang.translation['username'][Languages.selectedLanguage],
                    UserProvider.userName,
                    context),
                textFiled(
                    2,
                    lang.translation['phoneTitle'][Languages.selectedLanguage],
                    UserProvider.userPhone,
                    context),
                textFiled(
                    3,
                    lang.translation['caseProblem'][Languages.selectedLanguage],
                    AddServiceForm.desc,
                    context),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        Languages.selectedLanguage == 1
                            ? 'choose a date'
                            : "اختر موعدا",
                        style: Theme.of(context).textTheme.headline3,
                        textDirection: ui.TextDirection.rtl,
                      ),
                    ),
                  ],
                ),
                //date to order
                Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.symmetric(horizontal: 22),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Colors.grey[200],
                  ),
                  child: InkWell(
                    onTap: () => schedule(),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: Colors.indigo,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              DateFormat.jms().format(_selSchedule),
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              DateFormat.yMMMd().format(_selSchedule),
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                //GoogleMap
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                      builder: (context) => MapScreen(),
                    ))
                        .then((value) {
                      widget.stateFule(() {
                        animateTo(
                            UserProvider.latitude, UserProvider.longitude);
                      });
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                    padding: const EdgeInsets.all(8.0),
                    width: double.infinity,
                    height: 170.0,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: UserProvider.latitude != null
                            ? GoogleMap(
                                onTap: (argument) {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                    builder: (context) => MapScreen(),
                                  ))
                                      .then((value) {
                                    widget.stateFule(() {
                                      animateTo(UserProvider.latitude,
                                          UserProvider.longitude);
                                    });
                                  });
                                },
                                // onMapCreated: _onMapCreated,
                                liteModeEnabled:
                                    Platform.isAndroid ? true : false,
                                mapToolbarEnabled: false,
                                myLocationEnabled: false,
                                buildingsEnabled: false,
                                myLocationButtonEnabled: false,
                                onMapCreated: (controller) {
                                  _completer.complete(controller);
                                },
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                      double.parse(
                                          UserProvider.latitude.toString()),
                                      double.parse(
                                          UserProvider.longitude.toString())),
                                  zoom: 14.0,
                                ),
                                markers: markers,
                              )
                            : Icon(
                                Icons.map,
                                color: Colors.black45,
                                size: 60,
                              ),
                      ),
                    ),
                  ),
                ),
                //order now
                Row(
                  children: [
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).accentColor,
                        onPressed: () {
                          _key.currentState.save();
                          Provider.of<Orders>(context, listen: false)
                              .addOrder(
                                  name: AddServiceForm.name,
                                  phone: AddServiceForm.phone,
                                  desc: AddServiceForm.desc,
                                  lat: UserProvider.latitude,
                                  long: UserProvider.longitude,
                                  serviceId: widget.serviceId,
                                  schadule: _selSchedule.toString())
                              .then((value) {
                            _key.currentState.reset();
                            AddServiceForm.desc = null;
                            Navigator.pop(context);
                            int count = 0;
                            showCupertinoDialog(
                              context: context,
                              builder: (context) => CupertinoAlertDialog(
                                title: !value
                                    ? Text(
                                        Languages.selectedLanguage == 1
                                            ? 'Ordered not successfully'
                                            : "لم يتم الطلب بنجاح",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3,
                                      )
                                    : Text(
                                        Languages.selectedLanguage == 1
                                            ? 'Your order has been successfully completed. Thank you for choosing Sahla!'
                                            : 'تم إكمال طلبك بنجاح. شكرا لاختيارك سهلة!',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3,
                                      ),
                                actions: [
                                  CupertinoActionSheetAction(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .popUntil((route) => count++ == 2);
                                      },
                                      child: Text(
                                        Languages.selectedLanguage == 1
                                            ? 'ok'
                                            : 'موافق',
                                        style: TextStyle(
                                            color: Colors.redAccent,
                                            fontFamily: fonts),
                                      ))
                                ],
                              ),
                            );
                          });
                        },
                        child: Text(
                          lang.translation['addOrder']
                              [Languages.selectedLanguage],
                          style: Theme.of(context).textTheme.headline2,
                          textDirection: Languages.selectedLanguage == 0
                              ? ui.TextDirection.rtl
                              : ui.TextDirection.ltr,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Completer<GoogleMapController> _completer = Completer();

  Future<void> animateTo(double lat, double lng) async {
    final c = await _completer.future;
    final p = CameraPosition(target: LatLng(lat, lng), zoom: 14.4746);
    c.animateCamera(CameraUpdate.newCameraPosition(p));
  }

  Widget textFiled(int index, String hint, String selValue, context) {
    final lang = Provider.of<Languages>(context);
    return Padding(
      padding: const EdgeInsets.only(right: 18.0),
      child: CupertinoTextFormFieldRow(
        onTap: () => index == 4 ? schedule() : null,
        onSaved: (newValue) {
          if (index == 1) AddServiceForm.name = newValue;
          if (index == 2) AddServiceForm.phone = newValue;
          if (index == 3) AddServiceForm.desc = newValue;
        },
        readOnly: index == 4 ? true : false,
        style: Theme.of(context).textTheme.headline1,
        placeholder: hint,
        placeholderStyle: TextStyle(color: Colors.black26),
        initialValue: selValue,
        maxLines: index == 3 ? 3 : 1,
        textAlign: TextAlign.right,
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(5)),
      ),
    );
  }
}
