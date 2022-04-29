import 'package:back_button_interceptor/back_button_interceptor.dart';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:new_sahla/ecomerce/helpers/app_themes.dart';
import 'package:new_sahla/ecomerce/helpers/ecommerce_icons_icons.dart';
import 'package:new_sahla/ecomerce/model/SubCategory.dart';
import 'package:new_sahla/ecomerce/model/productShow.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/templetes/Category1FirstTemplate.dart';
import 'package:new_sahla/ecomerce/templetes/ProductMainTemplate.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class SubCategoryScreen extends StatefulWidget {
  final SubCategory subCategory;

  SubCategoryScreen({this.subCategory});

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  bool isSubSubCategoryOk = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // if(mounted)
    // setState(() {
    //   isSubSubCategoryOk=true;
    // });
    final allPro = Provider.of<AllProviders>(context, listen: false);
    allPro.fetchDataSubSubCategories(widget.subCategory.id).then((value) {
      if (mounted)
        setState(() {
          isSubSubCategoryOk = false;
        });
    });
    allPro.fetchDataSubCategoriesProducts(
        widget.subCategory.id, '_selectedChoice.sort', "store");
  }

  @override
  Widget build(BuildContext context) {
    final allPro = Provider.of<AllProviders>(context, listen: false);
    print('${allPro.subSubCategoriesProducts.length}wwwwwwwwwwwwww');
    print('${allPro.subCategoriesProducts.length}wwwwwwwwwwwwww');
    print('${allPro.categoriesProducts.length}wwwwwwwwwwwwww');
    // allPro.fetchDataSubSubCategories(widget.subCategory.id);
    // allPro.loadedAllCategoriesProducts = [];
    // allPro.loadedAllsubCategoriesProducts = [];
    print(AllProviders.isSubCateforyProductsOk);
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
          // body: CustomScrollView(
          //   slivers: <Widget>[
          //     AppBar(
          //       // forceElevated: true,
          //       centerTitle: true,
          //       title: Text(
          //         "${widget.subCategory.title}",
          //         textAlign: TextAlign.right,
          //         style: TextStyle(
          //             fontSize: 22,
          //             fontFamily: fonts,
          //             color: Colors.white,
          //             fontWeight: FontWeight.bold),
          //       ),
          //       leading: IconButton(onPressed: () {
          //         Navigator.pop(context);
          //       },icon: Icon(Icons.arrow_back_ios,
          //         color: Colors.white,),),
          //       // expandedHeight: 150,
          //       // backgroundColor: Theme.of(context).appBarTheme.color,
          //       // pinned: true,
          //       // actions: <Widget>[
          //       //   PopupMenuButton<Choice>(
          //       //     onSelected: _select,
          //       //     icon: Icon(Icons.filter_list),
          //       //     itemBuilder: (BuildContext context) {
          //       //       return choices.map((Choice choice) {
          //       //         return PopupMenuItem<Choice>(
          //       //           value: choice,
          //       //           child: Row(
          //       //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       //             children: <Widget>[
          //       //               Text(choice.title,style: Theme.of(context).textTheme.headline1,),
          //       //               Icon(
          //       //                 choice.icon,
          //       //                 color: Theme.of(context).primaryColor,
          //       //               ),
          //       //             ],
          //       //           ),
          //       //         );
          //       //       }).toList();
          //       //     },
          //       //   ),
          //       // ],
          //       iconTheme: IconThemeData(color: Colors.white),
          //       // flexibleSpace: FlexibleSpaceBar(
          //       //   background: FadeInImage(
          //       //     placeholder: AssetImage('assets/images/placeholder.png'),
          //       //     image: NetworkImage("${widget.subCategory.photo}"),
          //       //     fit: BoxFit.cover,
          //       //   ),
          //       // ),
          //     ),
          //     SliverList(
          //       delegate: SliverChildListDelegate([
          //         SizedBox(
          //           height: 15,
          //         ),
          //         Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: <Widget>[
          //             allPro.subSubCategories.length != 0
          //                 ? Consumer<AllProviders>  (
          //               builder: (context, setPro, _) {
          //                 if (isSubSubCategoryOk == true) {
          //                   return Shimmer.fromColors(
          //                     baseColor: Colors.black87,
          //                     highlightColor: Colors.white,
          //                     period: Duration(milliseconds: 700),
          //                     child: Container(
          //                       width: MediaQuery.of(context).size.width / 1.1,
          //                       child: GridView.builder(
          //                         physics: NeverScrollableScrollPhysics(),
          //                         shrinkWrap: true,
          //                         gridDelegate:
          //                         SliverGridDelegateWithFixedCrossAxisCount(
          //                           childAspectRatio: 0.75,
          //                           crossAxisSpacing: 10,
          //                           mainAxisSpacing: 10,
          //                           crossAxisCount: 2
          //                         ),
          //                         itemCount: 5,
          //                         itemBuilder: (context, index) {
          //                           return ClipRRect(
          //                             borderRadius:
          //                             BorderRadius.all(Radius.circular(10)),
          //                             clipBehavior: Clip.antiAlias,
          //                             child: Container(
          //                               width: MediaQuery.of(context).size.width / 1.1,
          //                               height:  MediaQuery.of(context).size.height*0.4,
          //                               decoration: BoxDecoration(
          //                                 color: Colors.white.withOpacity(0.1),
          //                                 borderRadius: BorderRadius.all(
          //                                   Radius.circular(10),
          //                                 ),
          //
          //                               ),
          //                             ),
          //                           );
          //                         },
          //                       ),
          //                     ),
          //                   );
          //                 } else {
          //                   return Container(
          //                     width: MediaQuery.of(context).size.width / 1.1,
          //                     //height: MediaQuery.of(context).size.height / 1.1,
          //                     child: GridView.builder(
          //                       physics: NeverScrollableScrollPhysics(),
          //                       shrinkWrap: true,
          //                       gridDelegate:
          //                       SliverGridDelegateWithMaxCrossAxisExtent(
          //                         maxCrossAxisExtent: 260,
          //                         childAspectRatio: 1.2,
          //                         crossAxisSpacing: 5.0,
          //                         mainAxisSpacing: 5.0,
          //                       ),
          //                       itemCount: setPro.subSubCategories.length,
          //                       itemBuilder: (context, index) {
          //                         return Category1FirstTemplate(
          //                           subCategory: setPro.subSubCategories[index],
          //                           isThird: true,
          //                         );
          //                       },
          //                     ),
          //                   );
          //                 }
          //               },
          //             )
          //                 : SizedBox(),
          //             Consumer<AllProviders>(
          //               builder: (ctx, pro, _) {
          //                 print("sub");
          //                 if (AllProviders.isSubCateforyProductsOk == false) {
          //                   return Shimmer.fromColors(
          //                     baseColor: Colors.grey.withOpacity(0.5),
          //                     highlightColor: Colors.white,
          //                     period: Duration(milliseconds: 700),
          //                     child: Container(
          //                       width: MediaQuery.of(context).size.width / 1.1,
          //                       child: GridView.builder(
          //                         physics: NeverScrollableScrollPhysics(),
          //                         shrinkWrap: true,
          //                         gridDelegate:
          //                             SliverGridDelegateWithMaxCrossAxisExtent(
          //                           maxCrossAxisExtent: 300,
          //                           childAspectRatio: 1 / 1.6,
          //                           crossAxisSpacing: 5.0,
          //                           mainAxisSpacing: 5.0,
          //                         ),
          //                         itemCount: 2,
          //                         itemBuilder: (context, index) {
          //                           return ClipRRect(
          //                             borderRadius:
          //                                 BorderRadius.all(Radius.circular(10)),
          //                             clipBehavior: Clip.antiAlias,
          //                             child: Container(
          //                               decoration: BoxDecoration(
          //                                 color: Colors.white,
          //                                 borderRadius: BorderRadius.all(
          //                                   Radius.circular(10),
          //                                 ),
          //                                 boxShadow: [
          //                                   BoxShadow(
          //                                     color:
          //                                         Colors.white.withOpacity(0.1),
          //                                     blurRadius: 0.0,
          //                                     spreadRadius:
          //                                         0.1, // has the effect of extending the shadow
          //                                     offset: Offset(
          //                                       0, // horizontal, move right 10
          //                                       0, // vertical, move down 10
          //                                     ),
          //                                   )
          //                                 ],
          //                               ),
          //                             ),
          //                           );
          //                         },
          //                       ),
          //                     ),
          //                   );
          //                 } else if (allPro.subCategoriesProducts.length == 0) {
          //                   return Container(
          //                     width: MediaQuery.of(context).size.width,
          //                     height: MediaQuery.of(context).size.height,
          //                     child: Container(
          //                       alignment: Alignment.topCenter,
          //                       margin: EdgeInsets.only(top: 20),
          //                       child: Column(
          //                         children: [
          //                           Text(
          //                             Languages.selectedLanguage == 0
          //                                 ? "
          //                                 : "No Products !",
          //                             style: TextStyle(
          //                                 fontSize: 20,
          //                                 fontFamily: fonts,
          //                                 color: Theme.of(context)
          //                                     .bottomAppBarColor),
          //                           ),
          //                           SizedBox(
          //                             height: 10,
          //                           ),
          //                           Icon(
          //                             EcommerceIcons.shopping_basket,
          //                             color: Theme.of(context).bottomAppBarColor,
          //                             size: 46,
          //                           ),
          //                         ],
          //                       ),
          //                     ),
          //                   );
          //                 } else {
          //                   return CategoryItemsTemplate(allPro: allPro);
          //                 }
          //               },
          //             ),
          //             SizedBox(
          //               height: 200,
          //             ),
          //           ],
          //         ),
          //       ]),
          //     ),
          //   ],
          // ),
          appBar: AppBar(
            // forceElevated: true,
            centerTitle: true,
            title: Text(
              "${widget.subCategory.title}",
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: 22,
                  fontFamily: fonts,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
            // expandedHeight: 150,
            // backgroundColor: Theme.of(context).appBarTheme.color,
            // pinned: true,
            // actions: <Widget>[
            //   PopupMenuButton<Choice>(
            //     onSelected: _select,
            //     icon: Icon(Icons.filter_list),
            //     itemBuilder: (BuildContext context) {
            //       return choices.map((Choice choice) {
            //         return PopupMenuItem<Choice>(
            //           value: choice,
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: <Widget>[
            //               Text(choice.title,style: Theme.of(context).textTheme.headline1,),
            //               Icon(
            //                 choice.icon,
            //                 color: Theme.of(context).primaryColor,
            //               ),
            //             ],
            //           ),
            //         );
            //       }).toList();
            //     },
            //   ),
            // ],
            iconTheme: IconThemeData(color: Colors.white),
            // flexibleSpace: FlexibleSpaceBar(
            //   background: FadeInImage(
            //     placeholder: AssetImage('assets/images/placeholder.png'),
            //     image: NetworkImage("${widget.subCategory.photo}"),
            //     fit: BoxFit.cover,
            //   ),
            // ),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  allPro.subSubCategories.length != 0
                      ? Consumer<AllProviders>(
                          builder: (context, setPro, _) {
                            if (isSubSubCategoryOk == true) {
                              return Shimmer.fromColors(
                                baseColor: Colors.black87,
                                highlightColor: Colors.white,
                                period: Duration(milliseconds: 700),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.1,
                                  child: GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            childAspectRatio: 0.75,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 10,
                                            crossAxisCount: 2),
                                    itemCount: 5,
                                    itemBuilder: (context, index) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        clipBehavior: Clip.antiAlias,
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.1,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.4,
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.1),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            } else {
                              return Container(
                                width: MediaQuery.of(context).size.width / 1.1,
                                //height: MediaQuery.of(context).size.height / 1.1,
                                child: GridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 260,
                                    childAspectRatio: 1.2,
                                    crossAxisSpacing: 5.0,
                                    mainAxisSpacing: 5.0,
                                  ),
                                  itemCount: setPro.subSubCategories.length,
                                  itemBuilder: (context, index) {
                                    return Category1FirstTemplate(
                                      subCategory:
                                          setPro.subSubCategories[index],
                                      isThird: true,
                                    );
                                  },
                                ),
                              );
                            }
                          },
                        )
                      : SizedBox(),
                  SizedBox(
                    height: 10,
                  ),
                  Consumer<AllProviders>(
                    builder: (ctx, pro, _) {
                      print("sub");
                      if (AllProviders.isSubCateforyProductsOk == false) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.withOpacity(0.5),
                          highlightColor: Colors.white,
                          period: Duration(milliseconds: 700),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.1,
                            child: GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 300,
                                childAspectRatio: 1 / 1.6,
                                crossAxisSpacing: 5.0,
                                mainAxisSpacing: 5.0,
                              ),
                              itemCount: 2,
                              itemBuilder: (context, index) {
                                return ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  clipBehavior: Clip.antiAlias,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.1),
                                          blurRadius: 0.0,
                                          spreadRadius: 0.1,
                                          // has the effect of extending the shadow
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
                      } else if (allPro.subCategoriesProducts.length == 0) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: Container(
                            alignment: Alignment.topCenter,
                            margin: EdgeInsets.only(top: 20),
                            child: Column(
                              children: [
                                Text(
                                  Languages.selectedLanguage == 0
                                      ? "لا توجد منتجات !"
                                      : "No Products !",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: fonts,
                                      color:
                                          Theme.of(context).bottomAppBarColor),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Icon(
                                  EcommerceIcons.shopping_basket,
                                  color: Theme.of(context).bottomAppBarColor,
                                  size: 46,
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return CategoryItemsTemplate(allPro: allPro);
                      }
                    },
                  ),
                  SizedBox(
                    height: 200,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryItemsTemplate extends StatelessWidget {
  const CategoryItemsTemplate({
    Key key,
    @required this.allPro,
    this.isCategory,
  }) : super(key: key);
  final AllProviders allPro;
  final bool isCategory;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width / 1.1,
        //height: MediaQuery.of(context).size.height / 4.1,
        child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 0.64 / 1,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisSpacing: 10,
            mainAxisSpacing: 15,
            children: allPro.subCategoriesProducts.map((item) {
              return ProductMainTemplate(
                product: ProductShow(
                    id: item.id,
                    title: item.title,
                    description: item.description,
                    price: item.price,
                    discount: item.discount,
                    discountPercentage: item.discountPercentage,
                    image: item.image,
                    isFavorite: item.isFavorite,
                    index: item.index,
                    isActive: item.isActive),
                isMain: false,
              );
            }).toList()));
  }
}

class CategoryItemsTemplate1 extends StatelessWidget {
  const CategoryItemsTemplate1({
    Key key,
    @required this.allPro,
    this.isCategory,
  }) : super(key: key);
  final AllProviders allPro;
  final bool isCategory;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width / 1.1,
        //height: MediaQuery.of(context).size.height / 4.1,
        child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 0.64 / 1,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisSpacing: 10,
            mainAxisSpacing: 15,
            children: allPro.mainCategoriesProducts.map((item) {
              return ProductMainTemplate(
                product: ProductShow(
                    id: item.id,
                    title: item.title,
                    description: item.description,
                    price: item.price,
                    discount: item.discount,
                    discountPercentage: item.discountPercentage,
                    image: item.image,
                    isFavorite: item.isFavorite,
                    index: item.index,
                    isActive: item.isActive),
                isMain: false,
              );
            }).toList()));
  }
}

class Choice {
  Choice({this.title, this.icon, this.sort});

  final String title;
  final IconData icon;
  final String sort;
  List<Choice> choices = <Choice>[
    Choice(
        title: Languages.selectedLanguage == 0 ? '' : "On Time",
        icon: FlutterIcons.clock_fea,
        sort: "created_at"),
    Choice(
        title: Languages.selectedLanguage == 0 ? ' ' : "On Price",
        icon: EcommerceIcons.percentage,
        sort: "price"),
    Choice(
        title: Languages.selectedLanguage == 0 ? '' : "On Letter",
        icon: Icons.label,
        sort: "name_${Languages.selectedLanguageStr}"),
  ];
}
