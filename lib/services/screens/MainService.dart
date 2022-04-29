import 'package:animate_icons/animate_icons.dart';
import 'package:delayed_display/delayed_display.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:new_sahla/ecomerce/helpers/app_themes.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/templetes/SliderTemplate.dart';
import 'package:new_sahla/services/model/Baner.dart';
import 'package:new_sahla/services/providers/Offers.dart';
import 'package:new_sahla/services/providers/Sections.dart';
import 'package:new_sahla/services/providers/Services.dart';
import 'package:new_sahla/services/templetes/offfer_Item.dart';
import 'package:new_sahla/services/templetes/section_item.dart';
import 'package:new_sahla/services/templetes/service_item.dart';
import 'package:new_sahla/services/widgets/serviceShimmer.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../draweer.dart';
import 'list_offer.dart';
import 'more_categories.dart';
import 'more_special.dart';

class MainService extends StatefulWidget {
  var drawerKey;

  MainService({Key key, this.drawerKey}) : super(key: key);

  @override
  State<MainService> createState() => _MainServiceState();
}

class _MainServiceState extends State<MainService> {
  bool isLoadingBanner = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoadingBanner = true;
    Provider.of<Services>(context, listen: false).fetchServices();
    Provider.of<Offers>(context, listen: false).fetchData();
    Provider.of<Bannsers>(context, listen: false)
        .getServiceBanner()
        .then((value) {
      setState(() {
        isLoadingBanner = false;
      });
    });
  }

  double lastItem = 0.0;

  int selIndex = 0;

  AnimateIconController controller;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final sections = Provider.of<Sections>(context, listen: false);
    sections.fetchSections();
  }

  @override
  Widget build(BuildContext context) {
    final sections = Provider.of<Sections>(context, listen: false);
    var dir =
        Languages.selectedLanguage == 0 ? TextDirection.rtl : TextDirection.ltr;
    final lang = Provider.of<Languages>(context);
    final mediaQuery = MediaQuery.of(context).size;
    return Directionality(
      textDirection: dir,
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        drawer: Drawers(
          isService: true,
        ),
        appBar: AppBar(
          elevation: 0,
          leading: Container(
            margin: EdgeInsets.all(6),
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Theme.of(context).appBarTheme.color,
              shape: BoxShape.circle,
            ),
            child: Builder(
              builder: (ctx) => InkWell(
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
            setState(() {
              isLoadingBanner = true;
              sections.isEverythingOkSections = false;
            });
            sections.fetchSections();
            Provider.of<Services>(context, listen: false).fetchServices();
            Provider.of<Bannsers>(context, listen: false)
                .getServiceBanner()
                .then((value) {
              setState(() {
                isLoadingBanner = false;
              });
            });
          },
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 33,
                ),
                //banner
                DelayedDisplay(
                  slidingBeginOffset: Offset(0, -2),
                  fadingDuration: Duration(milliseconds: 700),
                  child: Consumer<Bannsers>(
                    builder: (ctx, pro, _) {
                      if (isLoadingBanner == true) {
                        return bannerShimmer(context);
                      } else {
                        return Banners();
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 27,
                ),
                //sections
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        lang.translation['categories']
                            [Languages.selectedLanguage],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).bottomAppBarColor,
                            fontFamily: fonts,
                            fontSize: 20),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MoreCategories(),
                          ));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              lang.translation['moreTitle']
                                  [Languages.selectedLanguage],
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).accentColor,
                                  fontFamily: fonts,
                                  fontSize: 15),
                            ),
                            Icon(
                              Languages.selectedLanguage == 0
                                  ? Icons.keyboard_arrow_left
                                  : Icons.keyboard_arrow_right,
                              size: 18,
                              color: Theme.of(context).accentColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                DelayedDisplay(
                  slidingBeginOffset: Offset(4, 0),
                  fadingDuration: Duration(milliseconds: 700),
                  child: Consumer<Sections>(
                    builder: (ctx, sec, _) {
                      return Container(
                        margin: EdgeInsets.all(5),
                        width: mediaQuery.width,
                        height: mediaQuery.height * 0.2,
                        child: ListView.builder(
                            // shrinkWrap: true,
                            // gridDelegate:
                            //     SliverGridDelegateWithFixedCrossAxisCount(
                            //   crossAxisCount: 1,
                            //   childAspectRatio: 0.55 / 0.9,
                            //   crossAxisSpacing: 20,
                            //   mainAxisSpacing: 15,
                            // ),
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            itemCount: sec.sectionItems.length,
                            itemBuilder: (context, index) {
                              if (isLoadingBanner == true) {
                                return SectionShimmer(mediaQuery: mediaQuery);
                              } else {
                                return SectionItem(
                                  mediaQuery: mediaQuery,
                                  section: sec.sectionItems[index],
                                );
                              }
                            }),
                      );
                    },
                  ),
                ),
                // offers
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        lang.translation['latestNews']
                            [Languages.selectedLanguage],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).bottomAppBarColor,
                            fontFamily: fonts,
                            fontSize: 20),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ListOffer(),
                          ));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              lang.translation['moreTitle']
                                  [Languages.selectedLanguage],
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).accentColor,
                                  fontFamily: fonts,
                                  fontSize: 15),
                            ),
                            Icon(
                              Languages.selectedLanguage == 0
                                  ? Icons.keyboard_arrow_left
                                  : Icons.keyboard_arrow_right,
                              size: 18,
                              color: Theme.of(context).accentColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                DelayedDisplay(
                  slidingBeginOffset: Offset(4, 0),
                  fadingDuration: Duration(milliseconds: 700),
                  child: Consumer<Offers>(
                    builder: (ctx, off, _) {
                      return Container(
                        padding: EdgeInsets.only(bottom: 25),
                        width: MediaQuery.of(context).size.width * 1,
                        height: MediaQuery.of(context).size.height * 0.2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            itemCount: off.items.length,
                            itemBuilder: (context, index) {
                              print(off.isLoadOffer);
                              if (off.isLoadOffer == true) {
                                return shimmerOffer();
                              } else {
                                return OffferItem(
                                    mediaQuery: mediaQuery,
                                    offer: off.items[index]);
                              }
                            }),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        lang.translation['mostUsed']
                            [Languages.selectedLanguage],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).bottomAppBarColor,
                            fontFamily: fonts,
                            fontSize: 20),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MoreSpecial(),
                          ));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              lang.translation['moreTitle']
                                  [Languages.selectedLanguage],
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).accentColor,
                                  fontFamily: fonts,
                                  fontSize: 15),
                            ),
                            Icon(
                              Languages.selectedLanguage == 0
                                  ? Icons.keyboard_arrow_left
                                  : Icons.keyboard_arrow_right,
                              size: 18,
                              color: Theme.of(context).accentColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                //most used
                DelayedDisplay(
                  slidingBeginOffset: Offset(10, 0),
                  fadingDuration: Duration(milliseconds: 700),
                  child: Transform.translate(
                    offset: Offset(0, -90),
                    child: Consumer<Services>(
                      builder: (ctx, pers, _) {
                        if (isLoadingBanner == true) {
                          return serviceShimmer(mediaQuery: mediaQuery);
                        } else {
                          return StaggeredGridView.countBuilder(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              staggeredTileBuilder: (int index) =>
                                  new StaggeredTile.fit(1),
                              mainAxisSpacing: 4.0,
                              crossAxisSpacing: 4.0,
                              itemCount: pers.servicesMostUsed.length,
                              itemBuilder: (context, index) => ServiceItem(
                                    mediaQuery: mediaQuery,
                                    service: pers.servicesMostUsed[index],
                                  ));
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Shimmer bannerShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black87,
      highlightColor: Colors.white,
      period: Duration(milliseconds: 700),
      child: Container(
        height: 230,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.transparent,
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
              blurRadius: 0.0,
              spreadRadius: 0.1, // has the effect of extending the shadow
              offset: Offset(
                0, // horizontal, move right 10
                0, // vertical, move down 10
              ),
            )
          ],
        ),
      ),
    );
  }

  Shimmer shimmerOffer() {
    return Shimmer.fromColors(
      baseColor: Colors.black,
      highlightColor: Colors.white,
      period: Duration(milliseconds: 700),
      child: Container(
        height: 230,
        margin: EdgeInsets.all(8),
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(0.1),
        ),
      ),
    );
  }
}
