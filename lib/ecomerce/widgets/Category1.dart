
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/helpers/font.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';

import 'package:new_sahla/ecomerce/templetes/Category1FirstTemplate.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'SubCategoryScreen.dart';

class Category1 extends StatelessWidget {
  const Category1({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final allPro = Provider.of<AllProviders>(context);
    return Directionality(
      textDirection:  Languages.selectedLanguage == 1
          ? TextDirection.rtl:TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).appBarTheme.color,
          title:  Text(
            allPro.selectedCategoryName.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){
            Navigator.pop(context);
          }),
        ),
        body:  SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20,),
                  allPro.subCategories.length != 0
                      ? Consumer<AllProviders>(
                    builder: (context, setPro, _) {
                      if (setPro.isCategoryOffline == true) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.withOpacity(0.5),
                          highlightColor: Colors.white,
                          period: Duration(milliseconds: 700),
                          child: Container(
                            width:
                            MediaQuery.of(context).size.width / 1.1,
                            child: GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent:
                                setPro.catMainStyle == 0
                                    ? 300
                                    : 150,
                                childAspectRatio: 1 / 1.6,
                                crossAxisSpacing: 5.0,
                                mainAxisSpacing: 5.0,
                              ),
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10)),
                                  clipBehavior: Clip.antiAlias,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white
                                              .withOpacity(0.1),
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
                                );
                              },
                            ),
                          ),
                        );
                      }
                      else {
                        return Container(
                          width:
                          MediaQuery.of(context).size.width / 1.1,
                          //height: MediaQuery.of(context).size.height / 1.1,
                          child: GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                            SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 300,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 5.0,
                              mainAxisSpacing: 5.0,
                            ),
                            itemCount: setPro.subCategories.length,
                            itemBuilder: (context, index) {
                              return Category1FirstTemplate(
                                subCategory:
                                setPro.subCategories[index],
                                isThird: false,
                              );
                            },
                          ),
                        );
                      }
                    },
                  )
                      : SizedBox(),
                  allPro.mainCategoriesProducts.length != 0
                      ? Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 40, bottom: 30),
                    child: Center(
                      child: Text(
                        Languages.selectedLanguage == 0
                            ? "منتجات"
                            : "Products",
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: fonts,
                          color: Theme.of(context).bottomAppBarColor,
                        ),
                      ),
                    ),
                  )
                      : SizedBox(),
                  allPro.mainCategoriesProducts.length != 0
                      ? CategoryItemsTemplate(allPro: allPro)
                      : SizedBox(),
                  SizedBox(
                    height: 90,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );}}