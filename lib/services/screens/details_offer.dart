import 'package:back_button_interceptor/back_button_interceptor.dart';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/services/model/offer.dart';
import 'package:provider/provider.dart';
import 'package:date_format/date_format.dart';

import 'detail_service.dart';

//import 'package:reviews_slider/reviews_slider.dart';
class DetailsOffer extends StatefulWidget {
  static const routeName = '/post_pressed_screen';
  final Offer postData;

  DetailsOffer({this.postData});

  @override
  State<DetailsOffer> createState() => _DetailsOfferState();
}

class _DetailsOfferState extends State<DetailsOffer> {
  @override
  Widget build(BuildContext context) {
    final allPro = Provider.of<AllProviders>(context);
    final lang = Provider.of<Languages>(context);
    //final postData = ModalRoute.of(context).settings.arguments as Post;
    //final loadedNews = Provider.of<OthersProvider>(context).findById(productId);
    //final List<String> texts = loadedNews.text.split("*");
    //final Widget test = loadedNews.test;
    //print(test);
    //final lang = Provider.of<Languages>(context, listen: false);
    return Directionality(
      textDirection: Languages.selectedLanguage == 1
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: WillPopScope(
        onWillPop: () {
          allPro.NavBarShow(true);
          return Future.value(true);
        },
        child: Scaffold(
          // appBar: AppBar(
          //   title: Text(loadedProduct.title),
          // ),
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
                expandedHeight: 140,
                pinned: true,
                // title: Text(
                //   widget.postData.title,
                //   style: TextStyle(
                //       fontWeight: FontWeight.bold,
                //       fontFamily: fonts,
                //       color: Colors.white,
                //       fontSize: 22),
                // ),
                centerTitle: true,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
                //iconTheme: IconThemeData(color: Colors.white),
                backgroundColor: Theme.of(context).primaryColor,
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: widget.postData.id,
                    child: FadeInImage(
                      placeholder: AssetImage('assets/images/slider1.png'),
                      // height: MediaQuery.of(context).size.height * 0.35,
                      image: NetworkImage("${widget.postData.image}"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        boxShadow: [
                          const BoxShadow(
                            color: Colors.black12,
                            blurRadius: 20,
                            spreadRadius:
                                0.8, // has the effect of extending the shadow
                            offset: Offset(
                              0, // horizontal, move right 10
                              0, // vertical, move down 10
                            ),
                          )
                        ],
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        border: Border.all(color: Colors.white, width: 1)),
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 1.5,
                            child: Center(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    widget.postData.title,
                                    maxLines: 3,
                                    textAlign: Languages.selectedLanguage == 0
                                        ? TextAlign.right
                                        : TextAlign.left,
                                    style: TextStyle(
                                        fontFamily: 'tajawal',
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(),
                          Text(
                            widget.postData.desc,
                            textAlign: Languages.selectedLanguage == 0
                                ? TextAlign.right
                                : TextAlign.left,
                            textDirection: Languages.selectedLanguage == 0
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            style: TextStyle(
                                fontFamily: 'tajawal',
                                fontSize: 20,
                                color: Colors.blueGrey,
                                height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20.0),
            child: RaisedButton(
              color: Theme.of(context).appBarTheme.color,
              child: Text(
                Languages.selectedLanguage == 1 ? 'order now' : 'اطلب الان',
                style: Theme.of(context).textTheme.headline2,
              ),
              onPressed: () {
                showCupertinoModalBottomSheet(
                    animationCurve: Curves.easeInOutBack,
                    duration: Duration(milliseconds: 700),
                    useRootNavigator: false,
                    bounce: false,
                    context: context,
                    enableDrag: true,
                    isDismissible: true,
                    builder: (context) {
                      return StatefulBuilder(builder: (context, stateFule) {
                        return AddServiceForm(
                            serviceId: widget.postData.serviceId,
                            stateFule: stateFule);
                      });
                    });
              },
            ),
          ),
        ),
      ),
    );
  }
}
