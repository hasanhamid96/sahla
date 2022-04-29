import 'package:back_button_interceptor/back_button_interceptor.dart';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:new_sahla/ecomerce/helpers/ecommerce_icons_icons.dart';
import 'package:new_sahla/ecomerce/model/Category.dart';
import 'package:new_sahla/ecomerce/model/productShow.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/templetes/ProductMainTemplate.dart';
import 'package:new_sahla/ecomerce/widgets/SubCategoryScreen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class PressedMainCategoryScreen extends StatefulWidget {
  final Category category;

  PressedMainCategoryScreen({this.category});

  @override
  State<PressedMainCategoryScreen> createState() =>
      _PressedMainCategoryScreenState();
}

class _PressedMainCategoryScreenState extends State<PressedMainCategoryScreen> {
  Choice _selectedChoice;

  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {
      AllProviders.isMainCatProductsOk = false;
      AllProviders.onceMainCatProducts = false;
      // AllProviders.dataOfflineAllProductsCategory = null;
      _selectedChoice = choice;
    });
  }

  @override
  void initState() {
    super.initState();
    // AllProviders.dataOfflineAllProductsCategory = null;
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo) {
    print("BACK BUTTON!"); // Do some stuff.
    Provider.of<AllProviders>(context, listen: false).NavBarShow(true);
    // AllProviders.onceMainCategoryProducts = false;
    // AllProviders.onceSubProducts = false;
    Navigator.pop(context);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final allPro = Provider.of<AllProviders>(context, listen: false);
    allPro.fetchDataCategoriesProducts(
        widget.category.id, _selectedChoice.sort, "");
    return WillPopScope(
      onWillPop: () {
        allPro.NavBarShow(true);
        return Future.value(true);
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              forceElevated: true,
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50))),
              centerTitle: true,
              title: Text(
                "${widget.category.mainCategory}",
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              expandedHeight: 150,
              backgroundColor: Theme.of(context).primaryColor,
              pinned: true,
              actions: <Widget>[],
              iconTheme: IconThemeData(color: Colors.white),
              flexibleSpace: FlexibleSpaceBar(
                background: FadeInImage(
                  placeholder: AssetImage('assets/images/placeholder.png'),
                  image: NetworkImage("${widget.category.image}"),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(
                  height: 15,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SafeArea(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.all(15),
                        child: Text(
                          "${widget.category.mainCategory}",
                          textAlign: Languages.selectedLanguage == 0
                              ? TextAlign.right
                              : TextAlign.left,
                          style: TextStyle(
                              fontSize: 28,
                              color: Theme.of(context).bottomAppBarColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Consumer<AllProviders>(
                      builder: (ctx, pro, _) {
                        if (AllProviders.isMainCatProductsOk == false) {
                          print("main");
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
                                            color:
                                                Colors.white.withOpacity(0.1),
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
                        } else if (allPro.categoriesProducts.length == 0) {
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
                                        fontSize: 24,
                                        color: Theme.of(context)
                                            .bottomAppBarColor),
                                  ),
                                  SizedBox(
                                    height: 25,
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
                          return CategoryMainItemsTemplate(allPro: allPro);
                        }
                      },
                    ),
                  ],
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryMainItemsTemplate extends StatelessWidget {
  const CategoryMainItemsTemplate({
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
        childAspectRatio: 0.6 / 1,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisSpacing: 10,
        mainAxisSpacing: 15,
        children: allPro.categoriesProducts.map((item) {
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
        }).toList(),
      ),
    );
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
        title: Languages.selectedLanguage == 0 ? '' : "On Price",
        icon: EcommerceIcons.percentage,
        sort: "price"),
    Choice(
        title: Languages.selectedLanguage == 0 ? '' : "On Letter",
        icon: Icons.label,
        sort: "name_${Languages.selectedLanguageStr}"),
  ];
}
