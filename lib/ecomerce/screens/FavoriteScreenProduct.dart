import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/ecomerce/widgets/FavoriteNoProducts.dart';
import 'package:new_sahla/services/templetes/favorite_item_template.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final allPro = Provider.of<AllProviders>(context);
    final lang = Provider.of<Languages>(context, listen: false);
    var dir =
        Languages.selectedLanguage == 1 ? TextDirection.rtl : TextDirection.ltr;
    return Directionality(
      textDirection: dir,
      child: WillPopScope(
        onWillPop: () {
          allPro.NavBarShow(true);
          return Future.value(true);
        },
        child: Scaffold(
          appBar: AppBar(
            // backgroundColor: Theme.of(context).primaryColor,
            iconTheme: IconThemeData(color: Colors.white),
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
            title: Text(
              lang.translation['FavoriteTitle'][Languages.selectedLanguage],
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          body: Consumer<AllProviders>(
            builder: (ctx, pro, _) {
              if (pro.isFavoriteOk == false) {
                return Shimmer.fromColors(
                    baseColor: Colors.black87,
                    highlightColor: Colors.white,
                    period: Duration(milliseconds: 700),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 130,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
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
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 130,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
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
                    ));
              } else {
                if (pro.allFavoriteItems.length == 0) {
                  return FavoriteNoProducts();
                } else {
                  return SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.only(top: 20, bottom: 40),
                      width: MediaQuery.of(context).size.width,
                      //height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: allPro.allFavoriteItems.map((element) {
                            return FavoriteItemTemplate(
                              product: element,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
