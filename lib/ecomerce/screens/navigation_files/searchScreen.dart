import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:new_sahla/ecomerce/helpers/app_themes.dart';
import 'package:new_sahla/ecomerce/helpers/ecommerce_icons_icons.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/templetes/ProductMainTemplate.dart';
import 'package:new_sahla/ecomerce/widgets/SearchedWorldHistory.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class SearchScreen extends StatefulWidget {
  final String searchInitial;

  SearchScreen({this.searchInitial});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController myController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<Languages>(context, listen: false);
    final appProvider = Provider.of<AllProviders>(context, listen: false);
    var dir =
        Languages.selectedLanguage == 0 ? TextDirection.rtl : TextDirection.ltr;
    return Directionality(
      textDirection: dir,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          automaticallyImplyLeading: false,
          title: Text(
            lang.translation['searchTitle'][Languages.selectedLanguage],
            textAlign: Languages.selectedLanguage == 0
                ? TextAlign.right
                : TextAlign.left,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: Theme.of(context).bottomAppBarColor.withOpacity(0.3),
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                width: MediaQuery.of(context).size.width * 1,
                child: TextFormField(
                  controller: myController,
                  textInputAction: TextInputAction.search,
                  keyboardType: TextInputType.text,
                  onFieldSubmitted: (value) {
                    setState(() {
                      isLoading = true;
                    });
                    appProvider.search(value, context, lang).then((value) {
                      setState(() {
                        isLoading = false;
                      });
                    });
                  },
                  onChanged: (value) {
                    if (value == "") {
                      //appProvider.searchResult();
                      appProvider.search(value, context, lang);
                    }
                  },
                  textAlign: Languages.selectedLanguage == 1
                      ? TextAlign.left
                      : TextAlign.right,
                  style: TextStyle(
                    fontFamily: fonts,
                    color: Theme.of(context).bottomAppBarColor,
                  ),
                  decoration: new InputDecoration(
                      border: InputBorder.none,
                      hintText: lang.translation['searchThousndOfProducts']
                          [Languages.selectedLanguage],
                      hintStyle: TextStyle(
                        fontFamily: fonts,
                        color: Theme.of(context).bottomAppBarColor,
                      ),
                      labelStyle: TextStyle(fontFamily: fonts, fontSize: 23),
                      suffixIcon: Languages.selectedLanguage == 1
                          ? isLoading == false
                              ? Icon(
                                  EcommerceIcons.magnifying_glass,
                                  color: Theme.of(context).bottomAppBarColor,
                                  size: 20,
                                )
                              : CircularProgressIndicator()
                          : SizedBox(),
                      prefixIcon: Languages.selectedLanguage == 0
                          ? isLoading == false
                              ? Icon(
                                  EcommerceIcons.magnifying_glass,
                                  color: Theme.of(context).bottomAppBarColor,
                                  size: 20,
                                )
                              : CircularProgressIndicator()
                          : SizedBox(),
                      suffixStyle: TextStyle(
                          fontFamily: fonts,
                          color: Theme.of(context).primaryColor)),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              // Consumer<AllProviders>(
              //   builder: (ctx, pro, _) {
              //     if (pro.isEverythingOkSearchCat == false) {
              //       return loadingCat(context);
              //     } else {
              //       return Tags(
              //         itemCount: appProvider.searchCat.length,
              //         itemBuilder: (int index) {
              //           return Tooltip(
              //               message: appProvider.searchCat[index].name,
              //               child: ItemTags(
              //                 color: Theme.of(context).primaryColor,
              //                 textStyle:  TextStyle(fontSize: 14,fontFamily: fonts,color: Colors.white),
              //                 activeColor: Theme.of(context).primaryColor,
              //                 borderRadius: BorderRadius.all(Radius.circular(5)),
              //                 index: index,
              //                 customData: appProvider.searchCat[index].name,
              //                 // title:
              //                 //     "${appProvider.searchCat[index].products_count} - ${appProvider.searchCat[index].name}",
              //                 title: " ${appProvider.searchCat[index].name}",
              //                 singleItem: true,
              //                 elevation: 0,
              //                 onPressed: (item) {
              //                   myController.text = item.customData;
              //                   setState(() {
              //                     isLoading = true;
              //                   });
              //                   appProvider.onceSearchCategories = false;
              //                   appProvider
              //                       .searchCatProducts(
              //                           appProvider.searchCat[index].catType,
              //                           appProvider.searchCat[index].id,
              //                           context,
              //                           lang)
              //                       .then((value) {
              //                     setState(() {
              //                       print("this is the length : " +
              //                           appProvider.searchProducts.length
              //                               .toString());
              //                       isLoading = false;
              //                     });
              //                   });
              //                 },
              //               ));
              //         },
              //       );
              //     }
              //   },
              // ),
              SizedBox(
                height: 30,
              ),
              appProvider.searchProducts.length != 0
                  ? Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topCenter,
                          width: MediaQuery.of(context).size.width / 1.1,
                          //height: MediaQuery.of(context).size.height / 4.1,
                          child: GridView.builder(
                            itemCount: appProvider.searchProducts.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.6 / 1,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 15,
                              // crossAxisSpacing: 0,
                              // mainAxisSpacing: 0,
                            ),
                            itemBuilder: (ctx, index) {
                              return ProductMainTemplate(
                                product: appProvider.searchProducts[index],
                                isMain: false,
                              );
                            },
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    )
                  : appProvider.oldSearchResult.length > 0
                      ? Container(
                          margin: EdgeInsets.only(top: 30),
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width / 1.1,
                                margin: EdgeInsets.only(bottom: 10),
                                child: Languages.selectedLanguage == 0
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                appProvider.deleteSearch();
                                              });
                                            },
                                            child: Text(
                                              lang.translation['deleteTitle']
                                                  [Languages.selectedLanguage],
                                              style: TextStyle(
                                                fontFamily: fonts,
                                                color: Colors.green,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            lang.translation[
                                                    'searchHistoryTitle']
                                                [Languages.selectedLanguage],
                                            style: TextStyle(
                                              fontFamily: fonts,
                                              fontSize: 19,
                                              color: Theme.of(context)
                                                  .bottomAppBarColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            lang.translation[
                                                    'searchHistoryTitle']
                                                [Languages.selectedLanguage],
                                            style: TextStyle(
                                              fontFamily: fonts,
                                              fontSize: 19,
                                              color: Theme.of(context)
                                                  .bottomAppBarColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                appProvider.deleteSearch();
                                              });
                                            },
                                            child: Text(
                                              lang.translation['deleteTitle']
                                                  [Languages.selectedLanguage],
                                              style: TextStyle(
                                                fontFamily: fonts,
                                                color: Colors.green,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                              Container(
                                  alignment: Alignment.topCenter,
                                  padding: EdgeInsets.all(4),
                                  width:
                                      MediaQuery.of(context).size.width / 1.1,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .bottomAppBarColor
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(3),
                                    ),
                                  ),
                                  child: Column(
                                    children: appProvider.oldSearchResult
                                        .sublist(0,
                                            appProvider.oldSearchResult.length)
                                        .reversed
                                        .map((item) {
                                      return SearchedWorldHistory(
                                        text: item,
                                        controller: myController,
                                        context: context,
                                      );
                                    }).toList(),
                                  ))
                            ],
                          ),
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width / 1.6,
                          height: 200,
                          alignment: Alignment.topCenter,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.search,
                                  size: 80,
                                  color: Theme.of(context)
                                      .bottomAppBarColor
                                      .withOpacity(0.2),
                                ),
                                Text(
                                  lang.translation['youDidNotSearch']
                                      [Languages.selectedLanguage],
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: fonts,
                                    fontSize: 20,
                                    color: Theme.of(context)
                                        .bottomAppBarColor
                                        .withOpacity(0.4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
              SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Shimmer loadingCat(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.black87,
        highlightColor: Colors.white,
        period: Duration(milliseconds: 700),
        child: Container(
          width: MediaQuery.of(context).size.width / 1.1,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 80,
                    height: 30,
                  ),
                  Container(
                    width: 180,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
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
            ],
          ),
        ));
  }
}
