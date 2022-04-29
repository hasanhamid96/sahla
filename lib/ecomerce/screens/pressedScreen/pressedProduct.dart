import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:new_sahla/ecomerce/helpers/ShimmerProductLoading.dart';
import 'package:new_sahla/ecomerce/model/Product.dart';

import 'package:new_sahla/ecomerce/model/cartItemModel.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/providers/RepositoryServiceTodo.dart';
import 'package:new_sahla/ecomerce/providers/UserProvider.dart';
import 'package:new_sahla/ecomerce/screens/drawer_files/CartScreen.dart';
import 'package:new_sahla/ecomerce/templetes/SimilarItems.dart';
import 'package:new_sahla/ecomerce/widgets/ProductImageViewer.dart';
import 'package:provider/provider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:ui' as ui;

import '../LoginScreen.dart';
import 'ProductColorSizePressed.dart';
import 'ProductDetailsPressed.dart';
import 'ProductInfoPressed.dart';

class PressedProduct extends StatefulWidget {
  static const routeName = '/pressed-product';
  final bool pressedWithProductId;
  final int productid;
  final bool isMain;

  PressedProduct(
      {@required this.isMain, this.pressedWithProductId, this.productid});

  @override
  State<PressedProduct> createState() => _PressedProductState();
}

class _PressedProductState extends State<PressedProduct> {
  int currentIndex = 0;

  int imageIndex = 1;

  Future<bool> requestPop() {
    return new Future.value(true);
  }

  Future<List<CartItemModel>> future;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    super.dispose();
  }

  void showInSnackBar(String value) {
    final allPro = Provider.of<AllProviders>(context, listen: false);
    FocusScope.of(context).requestFocus(new FocusNode());
    ScaffoldMessenger.of(context)?.removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      content: RaisedButton.icon(
        onPressed: () async {
          allPro.getCartItems();
          final count = await RepositoryServiceTodo.cartsCount();
          allPro.refreshCartItem(count);
          Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => CartScreen(),
              ));
        },
        color: Colors.orangeAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        icon: Icon(
          CupertinoIcons.cart_fill,
          color: Colors.white,
        ),
        label: Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Text(
            Languages.selectedLanguage == 1
                ? 'press to Open Cart'
                : 'اضغط لفتح سلة التسوق',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontFamily: fonts,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      duration: Duration(seconds: 1),
      // action: SnackBarAction(
      //    label: Languages.selectedLanguage==1?'Open Cart':'
      //    textColor: Colors.orangeAccent,
      //   onPressed: () async{
      //     allPro.getCartItems();
      //     final count = await RepositoryServiceTodo.cartsCount();
      //     allPro.refreshCartItem(count);
      //   Navigator.push(context, CupertinoPageRoute(builder: (context) => CartScreen(),));
      // },),
    ));
  }

  void showInSnackBarForSignIn(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      action: UserProvider.isLogin == false
          ? SnackBarAction(
              label: "Sign in",
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    )).then((value) {});
              },
            )
          : SizedBox(),
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style:
            TextStyle(color: Colors.white, fontSize: 16.0, fontFamily: fonts),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 3),
    ));
  }

  void createCartItem(Product product) async {
    final cart = CartItemModel(
        product_id: product.id,
        name: product.name,
        photo: product.image,
        quantityTotal: product.pieces.length != 0
            ? AllProviders.selectedPiece.quantity
            : product.quantity,
        color_code: product.pieces.length != 0
            ? AllProviders.selectedPiece.color != null
                ? AllProviders.selectedPiece.color.replaceAll("#", "")
                : "No Color"
            : "No Color",
        size: product.pieces.length != 0
            ? AllProviders.selectedPiece.size
            : "No Size",
        quantity: ProductColorSizePressed.quantityCounter,
        pieceId: product.pieces.length != 0 ? AllProviders.selectedPiece.id : 0,
        price: product.pieces.length != 0
            ? AllProviders.selectedPiece.discount == null
                ? AllProviders.selectedPiece.price
                : AllProviders.selectedPiece.discount
            : product.discount != 0
                ? product.discount
                : product.price,
        earnedPoints: product.points,
        points: product.pointPrice);
    await RepositoryServiceTodo.addCart(
        cart,
        product.pieces.length != 0 ? AllProviders.selectedPiece.id : 0,
        context);
    setState(() {
      //id = cart.id;
      future = RepositoryServiceTodo.getAllCarts();
    });
    int count = await RepositoryServiceTodo.cartsCount();
    Provider.of<AllProviders>(context, listen: false).refreshCartItem(count);
    print(cart.id);
  }

  PageController controller = PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ProductColorSizePressed.quantityCounter = 1;
    final allposts = Provider.of<AllProviders>(context, listen: false);
    if (allposts.isProdLoaded)
      allposts.fetchDataAllProductsOnSimilar(
          allposts.allProduct.catType, allposts.allProduct.catId);
  }

  @override
  Widget build(BuildContext context) {
    final allPro = Provider.of<AllProviders>(context, listen: true);
    final lang = Provider.of<Languages>(context);
    print(AllProviders.isProductOk);
    return WillPopScope(
        onWillPop: () {
          if (AllProviders.isColorsNavigatorOpen == true) {
            Navigator.of(context).pop();
            AllProviders.isColorsNavigatorOpen = false;
          }
          if (widget.isMain == false) {
            allPro.NavBarShow(true);
          }
          return Future.value(true);
        },
        child: Directionality(
          textDirection: Languages.selectedLanguage == 1
              ? ui.TextDirection.rtl
              : ui.TextDirection.ltr,
          child: Scaffold(
            key: _scaffoldKey,
            body: !allPro.isProdLoaded
                ? ShimmerProductLoading()
                : NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverAppBar(
                          automaticallyImplyLeading: true,
                          leading: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(allPro.allProduct.name),
                          centerTitle: true,
                          iconTheme: IconThemeData(
                            color: Colors.white,
                          ),
                          expandedHeight: 300.0,
                          floating: false,
                          pinned: true,
                          backgroundColor: Theme.of(context).appBarTheme.color,
                          flexibleSpace: FlexibleSpaceBar(
                            centerTitle: true,
                            // title: Text("Collapsing Toolbar",
                            //     style: TextStyle(
                            //       color: Colors.white,
                            //       fontSize: 16.0,
                            // fontFamily: fonts
                            //     )),
                            background: AllProviders.isProductOk == false
                                ? Center(
                                    child: CircularProgressIndicator
                                        .adaptive()) // =========== here is the loading of the shimmer
                                : InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProductImageViewer(
                                            pics: allPro.allProduct.images,
                                            product: allPro.allProduct,
                                            currentIndex: currentIndex,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: 330,
                                      child: Stack(
                                        children: <Widget>[
                                          ExtendedImageGesturePageView.builder(
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              var item = allPro.allProduct
                                                  .images[index].image;
                                              Widget image =
                                                  ExtendedImage.network(
                                                item,
                                                enableLoadState: true,
                                                initGestureConfigHandler: (s) {
                                                  return GestureConfig(
                                                    inPageView: true,
                                                    initialScale: 1.0,
                                                    //you can cache gesture state even though page view page change.
                                                    //remember call clearGestureDetailsCache() method at the right time.(for example,this page dispose)
                                                    cacheGesture: true,
                                                  );
                                                },
                                                fit: BoxFit.cover,
                                                mode: ExtendedImageMode.gesture,
                                                cache: true,
                                              );
                                              image = Container(
                                                child: image,
                                              );
                                              if (index == currentIndex) {
                                                return image;
                                              } else {
                                                return image;
                                              }
                                            },
                                            itemCount:
                                                allPro.allProduct.images.length,
                                            onPageChanged: (int index) {
                                              currentIndex = index;
                                              setState(() {
                                                imageIndex = index + 1;
                                              });
                                              //    rebuild.add(index);
                                            },
                                            controller: controller,
                                            scrollDirection: Axis.horizontal,
                                          ),
                                          Container(
                                            alignment: Alignment.bottomLeft,
                                            child: Container(
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(5),
                                                ),
                                                color: Colors.white
                                                    .withOpacity(0.4),
                                              ),
                                              child: Text(
                                                "$imageIndex / ${allPro.allProduct.images.length}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: fonts,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ];
                    },
                    body: Consumer<AllProviders>(
                      builder: (ctx, pro, _) {
                        if (AllProviders.isProductOk == false) {
                          return ShimmerProductLoading(); // =========== here is the loading of the shimmer
                        } else {
                          return SingleChildScrollView(
                            child: Column(children: <Widget>[
                              allPro.allProduct.images.length != 1
                                  ? Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 100,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: allPro.allProduct.images
                                              .map((photo) {
                                            return InkWell(
                                              onTap: () {
                                                setState(() {
                                                  controller.animateToPage(
                                                      photo.index,
                                                      duration: Duration(
                                                          milliseconds: 300),
                                                      curve: Curves.ease);
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Theme.of(context)
                                                            .bottomAppBarColor,
                                                        width: photo.index ==
                                                                currentIndex
                                                            ? 2
                                                            : 0)),
                                                child: Image.network(
                                                  photo.image,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              Container(
                                margin: EdgeInsets.all(5),
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 5,
                                      spreadRadius:
                                          0.3, // has the effect of extending the shadow
                                      offset: Offset(
                                        0, // horizontal, move right 10
                                        0, // vertical, move down 10
                                      ),
                                    )
                                  ],
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    ProductDetailsPressed(
                                      product: allPro.allProduct,
                                    ),
                                    Divider(
                                      thickness: 1,
                                    ),
                                    ProductColorSizePressed(
                                      product: allPro.allProduct,
                                    ),
                                    Divider(),
                                    ProductInfoPressed(
                                      product: allPro.allProduct,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  color: Theme.of(context).primaryColor,
                                ),
                                width: MediaQuery.of(context).size.width * 0.97,
                                child: FlatButton(
                                  disabledColor: Colors.grey,
                                  color: Theme.of(context).appBarTheme.color,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.5,
                                    padding: EdgeInsets.all(15),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            CupertinoIcons.cart_badge_plus,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            lang.translation['addToCart']
                                                [Languages.selectedLanguage],
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              fontFamily: fonts,
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (allPro.allProduct.pieces.length != 0) {
                                      if (AllProviders.selectedPiece != null) {
                                        // if (AllProviders.selectedPiece.quantity > 0) {
                                        allPro.cartItemsAll = null;
                                        createCartItem(allPro.allProduct);
                                        showInSnackBar(
                                          Languages.selectedLanguage == 0
                                              ? "تمت إضافة المنتج إلى سلة التسوق"
                                              : "Product have been add to cart",
                                        );
                                        /*   } else {
                                  showInSnackBar(
                                    Languages.selectedLanguage == 0
                                        ? "
                                        : "Product Out of stock",
                                  );
                                }*/
                                      } else {
                                        // if (allPro.allProduct.quantity > 0) {
                                        showInSnackBar(
                                          Languages.selectedLanguage == 0
                                              ? "الرجاء تحديد اللون أو الحجم"
                                              : "Please select color or size",
                                        );
                                        // } else {
                                        //   showInSnackBar(
                                        //     Languages.selectedLanguage == 0
                                        //         ? "
                                        //         : "Product Out of stock",
                                        //   );
                                        // }
                                      }
                                    } else {
                                      // if (allPro.allProduct.quantity != 0) {
                                      allPro.cartItemsAll = null;
                                      createCartItem(allPro.allProduct);
                                      showInSnackBar(
                                        Languages.selectedLanguage == 0
                                            ? "تمت إضافة المنتج إلى سلة التسوق"
                                            : "Product have been add to cart",
                                      );
                                      // } else {
                                      //   showInSnackBar(
                                      //     Languages.selectedLanguage == 0
                                      //         ? "
                                      //         : "Product Out of stock",
                                      //   );
                                      // }
                                    }
                                  },
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 1.1,
                                padding: EdgeInsets.all(15),
                                child: Text(
                                  lang.translation['similarProducts']
                                      [Languages.selectedLanguage],
                                  textAlign: Languages.selectedLanguage == 0
                                      ? TextAlign.right
                                      : TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: fonts,
                                      color:
                                          Theme.of(context).bottomAppBarColor),
                                ),
                              ),
                              Directionality(
                                  textDirection: Languages.selectedLanguage == 0
                                      ? ui.TextDirection.rtl
                                      : ui.TextDirection.ltr,
                                  child:
                                      SimilarItems(product: allPro.allProduct)),
                              SizedBox(
                                height: 20,
                              ),
                            ]),
                          );
                        }
                      },
                    ),
                  ),
          ),
        ));
  }
}

class ShimmerProductLoading extends StatelessWidget {
  const ShimmerProductLoading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) {
    return Directionality(
      textDirection: Languages.selectedLanguage == 1
          ? ui.TextDirection.rtl
          : ui.TextDirection.ltr,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // AppBar(
            //   backgroundColor: Theme.of(context).appBarTheme.color,
            //   centerTitle: true,
            //   title: Text('
            // ),
            Shimmer.fromColors(
                baseColor: Colors.black87,
                highlightColor: Colors.white,
                period: Duration(milliseconds: 700),
                child: Container(
                  //width: MediaQuery.of(context).size.width / 1.1,
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 330,
                        decoration: BoxDecoration(
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
                        width: MediaQuery.of(context).size.width / 1.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: 80,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
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
                            Container(
                              width: 180,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
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
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 280,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
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
                        width: 280,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
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
                        width: 580,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
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
                )),
          ],
        ),
      ),
    );
  }
}
