import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:new_sahla/ecomerce/model/Product.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/providers/UserProvider.dart';
import 'package:provider/provider.dart';

class ProductDetailsPressed extends StatelessWidget {
  final Product product;

  ProductDetailsPressed({this.product});

  @override
  Widget build(BuildContext context) {
    final allpro = Provider.of<AllProviders>(context, listen: true);
    Future<bool> onLikeButtonTapped(bool isLiked) async {
      print(isLiked);
      Future.delayed(const Duration(milliseconds: 500), () {
        if (isLiked == false) {
          allpro.insertFavorite(product.id).then((value) {
            allpro.changeFavoriteValue(product.index, isLiked);
          });
        } else {
          allpro.deleteFavorite(product.id, UserProvider.userId).then((value) {
            allpro.changeFavoriteValue(product.index, isLiked);
          });
        }
      });
      return !isLiked;
    }

    return Container(
      //margin: EdgeInsets.all(10),
      // padding: EdgeInsets.all(20),
      // width: double.infinity,
      // decoration: BoxDecoration(
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.grey.withOpacity(0.2),
      //       blurRadius: 5,
      //       spreadRadius: 0.3, // has the effect of extending the shadow
      //       offset: Offset(
      //         0, // horizontal, move right 10
      //         0, // vertical, move down 10
      //       ),
      //     )
      //   ],
      //   color: Colors.white,
      // ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    child: Center(
                      child: Text(
                        AllProviders.selectedPiece == null
                            ? product.discount == 0
                                ? allpro.numToString(product.price.toString()) +
                                    ' ' +
                                    AllProviders.currency
                                : allpro.numToString(
                                        product.discount.toString()) +
                                    ' ' +
                                    AllProviders.currency
                            : AllProviders.selectedPiece.discount == null
                                ? allpro.numToString(AllProviders
                                        .selectedPiece.price
                                        .toString()) +
                                    ' ' +
                                    AllProviders.currency
                                : allpro.numToString(AllProviders
                                        .selectedPiece.discount
                                        .toString()) +
                                    ' ' +
                                    AllProviders.currency,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontFamily: 'tajawal',
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 23),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  product.discountPercentage != null &&
                          AllProviders.selectedPiece == null
                      ? Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Center(
                                child: Text(
                                  product.discount != 0
                                      ? "${allpro.numToString(product.price.toString())}"
                                              ' ' +
                                          AllProviders.currency
                                      : "${allpro.numToString(product.discount.toString())}",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontFamily: 'tajawal',
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    decoration: TextDecoration.lineThrough,
                                    decorationThickness: 10,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Container(
                              //padding: EdgeInsets.only(top: 4),
                              margin: EdgeInsets.only(bottom: 8),
                              color: Colors.redAccent.withOpacity(0.3),
                              child: Center(
                                child: Text(
                                  "${product.discountPercentage.toStringAsFixed(1)}%",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : AllProviders.selectedPiece != null
                          ? AllProviders.selectedPiece.discount != null
                              ? Row(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: Center(
                                        child: Text(
                                          AllProviders.selectedPiece.discount !=
                                                  null
                                              ? "${allpro.numToString(AllProviders.selectedPiece.price.toString())}"
                                                      ' ' +
                                                  AllProviders.currency
                                              : "${allpro.numToString(AllProviders.selectedPiece.discount.toString())}",
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontFamily: 'tajawal',
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                            decoration:
                                                TextDecoration.lineThrough,
                                            decorationThickness: 10,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 4),
                                      margin: EdgeInsets.only(bottom: 8),
                                      color: Colors.redAccent.withOpacity(0.3),
                                      child: Center(
                                        child: Text(
                                          "${AllProviders.selectedPiece.discountPercentage.toStringAsFixed(1)}%",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : SizedBox()
                          : SizedBox(),
                  Container(
                    padding: EdgeInsets.all(5),
                    width: 150,
                    child: Center(
                      child: Text(
                        product.note != null ? product.note : "",
                        // "
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'tajawal',
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          decorationThickness: 10,
                        ),
                        //  overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              LikeButton(
                size: 30,
                isLiked: product.isFavorite,
                onTap: onLikeButtonTapped,
                circleColor: CircleColor(
                    start: Theme.of(context).primaryColor,
                    end: Theme.of(context).primaryColor),
                bubblesColor: BubblesColor(
                  dotPrimaryColor: Theme.of(context).primaryColor,
                  dotSecondaryColor: Theme.of(context).primaryColor,
                ),
                likeBuilder: (bool isLiked) {
                  return Icon(
                    Icons.favorite,
                    color: isLiked
                        ? Theme.of(context).primaryColor
                        : Colors.grey.withOpacity(0.4),
                    size: 30,
                  );
                },
              ),
            ],
          ),
          if (product.pointPrice.toString() != '0')
            FittedBox(
              fit: BoxFit.cover,
              child: Center(
                child: Card(
                  elevation: 0,
                  color: Color.fromRGBO(223, 248, 245, 1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 18),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/iconbanner.png',
                          width: 20,
                          height: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${product.pointPrice}',
                          style: Theme.of(context).textTheme.headline1,
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          Column(
            children: <Widget>[
              Container(
                child: Text(
                  "${product.name}",
                  textAlign: Languages.selectedLanguage == 0
                      ? TextAlign.justify
                      : TextAlign.left,
                  style: TextStyle(
                      fontFamily: 'tajawal',
                      color: Colors.black87,
                      fontWeight: FontWeight.w300,
                      fontSize: 21),
                  textDirection: TextDirection.rtl,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
