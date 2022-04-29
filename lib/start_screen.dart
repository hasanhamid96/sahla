import 'package:delayed_display/delayed_display.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_sahla/services/helpers/Rating.dart';
import 'package:new_sahla/services/screens/NavBottomServiceBar.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ecomerce/providers/Languages.dart';
import 'ecomerce/providers/UserProvider.dart';
import 'ecomerce/providers/AllProviders.dart';
import 'ecomerce/screens/navigation_files/MainScreen.dart';

class StartScreen extends StatefulWidget {
  int orderId;
  String type;

  StartScreen({this.orderId, this.type});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  var datatat;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreferences.getInstance().then((value) {
      datatat = value.getInt("language");
    });
    if (widget.orderId != null) {
      Future.delayed(Duration(seconds: 1)).then((value) {
        Rating.showRatingDialog(context, widget.orderId.toString(),
            isService: widget.type == 'store' ? false : true,
            orderId: widget.orderId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<Languages>(context);
    final mediaQ = MediaQuery.of(context).size;
    // rating(context);
    final allPro = Provider.of<AllProviders>(context);
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
              ),
              DelayedDisplay(
                slidingBeginOffset: Offset(0, -2),
                fadingDuration: Duration(milliseconds: 400),
                child: Column(
                  children: [
                    Text(
                      lang.translation['sahla'][Languages.selectedLanguage],
                      style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'ithra',
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).accentColor),
                    ),
                    Text(lang.translation['hello'][Languages.selectedLanguage],
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: fonts,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).accentColor)),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              //service
              DelayedDisplay(
                slidingBeginOffset: Offset(2, 0),
                fadingDuration: Duration(milliseconds: 400),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NavBottomServiceBar(),
                        ));
                  },
                  child: Container(
                    height: mediaQ.height * 0.29,
                    width: mediaQ.width,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Stack(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'assets/images/shoping2.jpeg',
                                fit: BoxFit.cover,
                              )),
                          Positioned(
                              top: 0,
                              right: 0,
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        ),
                                        gradient: LinearGradient(colors: [
                                          Theme.of(context).primaryColor,
                                          Colors.lightBlueAccent
                                        ])),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 5),
                                      child: Text(
                                        Languages.selectedLanguage == 1
                                            ? 'services'
                                            : 'خدمات',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: fonts,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                        textDirection: TextDirection.rtl,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              //store
              DelayedDisplay(
                slidingBeginOffset: Offset(-2, 0),
                fadingDuration: Duration(milliseconds: 400),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainScreen(),
                        ));
                    allPro.NavBarShow(true);
                  },
                  child: Container(
                    height: mediaQ.height * 0.3,
                    width: mediaQ.width,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Stack(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Center(
                                child: Image.asset(
                                  'assets/images/shop2.jpeg',
                                  height: mediaQ.height * 0.3,
                                  width: mediaQ.width * 0.63,
                                  fit: BoxFit.cover,
                                ),
                              )),
                          // Positioned(
                          //     bottom: 20,
                          //     left: 12,
                          //     child: FlatButton(onPressed:null, child: Text(lang.translation['browsing'][Languages.selectedLanguage],style: TextStyle(color: Colors.white),))),
                          // Positioned(
                          //     bottom: 20,
                          //     left: 12,
                          //     child: Column(
                          //       children: [
                          //         Text(lang.translation['speedingDeliver'][Languages.selectedLanguage],style: TextStyle(color: Colors.black54),textDirection: TextDirection.rtl,),
                          //       ],
                          //     )),
                          // Text(lang.translation['loc'][Languages.selectedLanguage],style: TextStyle(color: Colors.black54),textDirection: TextDirection.rtl,),
                          Positioned(
                              top: 0,
                              right: 0,
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        ),
                                        gradient: LinearGradient(colors: [
                                          Colors.red,
                                          Colors.redAccent.withOpacity(0.3)
                                        ])),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 5),
                                      child: Text(
                                        Languages.selectedLanguage == 1
                                            ? 'Store'
                                            : 'متجر',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: fonts,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                        textDirection: TextDirection.rtl,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // FlatButton(onPressed: (){
              //   Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
              // }, child: Text('
            ],
          ),
        ),
      ),
    );
  }
}
