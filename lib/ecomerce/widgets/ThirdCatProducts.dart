import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/helpers/app_themes.dart';
import 'package:new_sahla/ecomerce/helpers/ecommerce_icons_icons.dart';
import 'package:new_sahla/ecomerce/model/SubCategory.dart';
import 'package:new_sahla/ecomerce/model/productShow.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/ecomerce/templetes/ProductMainTemplate.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ThirdCatProducts extends StatefulWidget {
  SubCategory subCategory;

  ThirdCatProducts({Key key, this.subCategory}) : super(key: key);

  @override
  State<ThirdCatProducts> createState() => _ThirdCatProductsState();
}

class _ThirdCatProductsState extends State<ThirdCatProducts> {
  bool isSubSubCateforyProductsOk = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AllProviders>(context, listen: false)
        .fetchDataSubSubCategoriesProducts(
            widget.subCategory.id, '_selectedChoice.sort', "")
        .then((value) {
      if (mounted)
        setState(() {
          isSubSubCateforyProductsOk = false;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    final allPro = Provider.of<AllProviders>(context, listen: false);
    var dir =
        Languages.selectedLanguage == 0 ? TextDirection.rtl : TextDirection.ltr;
    return WillPopScope(
      onWillPop: () async {
        allPro.clearProd();
        Navigator.pop(context);
        return false;
      },
      child: Directionality(
        textDirection: dir,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "${widget.subCategory.title}",
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: 22,
                  fontFamily: fonts,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                onPressed: () {
                  allPro.clearProd();
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Consumer<AllProviders>(
                    builder: (ctx, pro, _) {
                      print("sub sub");
                      if (isSubSubCateforyProductsOk) {
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
                      } else if (allPro.subSubCategoriesProducts.length == 0) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          alignment: Alignment.topCenter,
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
                                      fontSize: 22,
                                      fontFamily: fonts,
                                      color:
                                          Theme.of(context).bottomAppBarColor),
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
                        return ProductItemsTemplate(allPro: allPro);
                      }
                    },
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

class ProductItemsTemplate extends StatelessWidget {
  const ProductItemsTemplate({
    Key key,
    @required this.allPro,
  }) : super(key: key);
  final AllProviders allPro;

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
          children: allPro.subSubCategoriesProducts.map((item) {
            return ProductMainTemplate(
              product: ProductShow(
                id: item.id,
                title: item.title,
                description: item.description,
                price: item.price,
                discount: item.discount,
                isActive: item.isActive,
                discountPercentage: item.discountPercentage,
                image: item.image,
                isFavorite: item.isFavorite,
                index: item.index,
              ),
              isMain: false,
            );
          }).toList()),
    );
  }
}
