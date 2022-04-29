import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:like_button/like_button.dart';
import 'package:new_sahla/ecomerce/model/productShow.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/providers/UserProvider.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/ecomerce/screens/pressedScreen/pressedProduct.dart';
import 'package:provider/provider.dart';

class ProductMainTemplate extends StatefulWidget {
  final ProductShow product;
  final bool isMain;

  ProductMainTemplate({@required this.product, @required this.isMain});

  @override
  State<ProductMainTemplate> createState() => _ProductMainTemplateState();
}

class _ProductMainTemplateState extends State<ProductMainTemplate> {
  String imageName;

  @override
  void initState() {
    imageName = widget.product.image.split("/").last;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final allPro = Provider.of<AllProviders>(context, listen: false);
    final lang = Provider.of<Languages>(context, listen: false);
    //print(product.index);
    Future<bool> onLikeButtonTapped(bool isLiked) async {
      if (UserProvider.isLogin) {
        print(isLiked);
        Future.delayed(const Duration(milliseconds: 500), () {
          if (isLiked == false) {
            allPro.insertFavorite(widget.product.id).then((value) {
              allPro.changeFavoriteValue(widget.product.index, isLiked);
            });
          } else {
            allPro
                .deleteFavorite(widget.product.id, UserProvider.userId)
                .then((value) {
              allPro.changeFavoriteValue(widget.product.index, isLiked);
            });
          }
        });
        return !isLiked;
      } else
        showDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: Text(
              lang.translation['signinRequire'][Languages.selectedLanguage],
              style: Theme.of(context).textTheme.headline1,
            ),
            actions: [],
          ),
        );
      return isLiked;
    }

    return InkWell(
      onTap: () {
        print('third product');
        if (widget.product.isActive == true) {
          //setState(() {
          // allPro.NavBarShow(false);
          // });
          allPro.fetchDataProduct(widget.product.id);
          AllProviders.isProductSimilarMainOk = false;
          AllProviders.onceSimilar = false;
          AllProviders.isProductOk = false;
          AllProviders.selectedPiece = null;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PressedProduct(
                isMain: widget.isMain,
              ),
            ),
          );
        } else
          print('third product not Active');
      },
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              border: Border.all(color: Colors.grey.withOpacity(0.1)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 1.0,
                    offset: Offset(0, 2),
                    spreadRadius: 0.2)
              ]),
          child: Stack(
            children: [
              Column(
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    child: Stack(children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        child: CachedNetworkImage(
                          height: 135,
                          width: 200,
                          fit: BoxFit.contain,
                          fadeInCurve: Curves.bounceOut,
                          imageUrl: widget.product.image
                              .replaceFirst("large", "small"),
                          placeholder: (context, url) {
                            return Image.asset(
                              "assets/images/placeholder.png",
                              fit: BoxFit.fitWidth,
                            );
                          },
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                      widget.product.discount != 0
                          ? Container(
                              padding: EdgeInsets.all(4),
                              margin: EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).accentColor,
                                  borderRadius: Languages.selectedLanguage == 1
                                      ? BorderRadius.only(
                                          bottomRight: Radius.circular(15),
                                          topLeft: Radius.circular(10),
                                        )
                                      : BorderRadius.only(
                                          bottomLeft: Radius.circular(15),
                                          topRight: Radius.circular(10),
                                        )),
                              child: Text(
                                Languages.selectedLanguage == 1
                                    ? "sale"
                                    : "تخفيض السعر",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: fonts,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : SizedBox(),
                    ]),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: 4,
                      left: 5,
                      right: 5,
                      bottom: 4,
                    ),
                    child: Text(
                      '${widget.product.title}',
                      textDirection: Languages.selectedLanguage == 0
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 13,
                          fontFamily: fonts),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Languages.selectedLanguage == 0
                          ? LikeButton(
                              size: 30,
                              isLiked: widget.product.isFavorite,
                              circleColor: CircleColor(
                                  start: Theme.of(context).primaryColor,
                                  end: Theme.of(context).primaryColor),
                              bubblesColor: BubblesColor(
                                dotPrimaryColor: Theme.of(context).primaryColor,
                                dotSecondaryColor:
                                    Theme.of(context).primaryColor,
                              ),
                              onTap: onLikeButtonTapped,
                              likeBuilder: (bool isLiked) {
                                return Icon(
                                  Icons.favorite,
                                  color: isLiked
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey.withOpacity(0.4),
                                  size: 30,
                                );
                              },
                            )
                          : SizedBox(),
                      Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.only(top: 10),
                          child: widget.product.discount == 0
                              ? Text(
                                  "${allPro.numToString(widget.product.price.toString())} ${AllProviders.currency}",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontFamily: fonts,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    decorationThickness: 3,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                )
                              : Column(
                                  children: [
                                    Text(
                                      "${allPro.numToString(widget.product.discount.toString())} ${AllProviders.currency}",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontFamily: fonts,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        decorationThickness: 3,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      "${allPro.numToString(widget.product.price.toString())} ${AllProviders.currency}",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontFamily: fonts,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        decoration: TextDecoration.lineThrough,
                                        decorationThickness: 3,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                )
                          // Text(
                          //   widget.product.discount == '0'
                          //       ? "${AllProviders.numToString(widget.product.price)}" ' ' + AllProviders.currency
                          //       : "${AllProviders.numToString(widget.product.discount)}" ' ' + AllProviders.currency,
                          //   style: TextStyle(
                          //       color: Colors.black,
                          //       fontSize: 20,
                          //       fontWeight: FontWeight.bold),
                          // ),
                          ),
                      Languages.selectedLanguage == 1
                          ? LikeButton(
                              size: 30,
                              isLiked: widget.product.isFavorite,
                              circleColor: CircleColor(
                                  start: Theme.of(context).primaryColor,
                                  end: Theme.of(context).primaryColor),
                              bubblesColor: BubblesColor(
                                dotPrimaryColor: Theme.of(context).primaryColor,
                                dotSecondaryColor:
                                    Theme.of(context).primaryColor,
                              ),
                              onTap: onLikeButtonTapped,
                              likeBuilder: (bool isLiked) {
                                return Icon(
                                  Icons.favorite,
                                  color: isLiked
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey.withOpacity(0.4),
                                  size: 30,
                                );
                              },
                            )
                          : SizedBox(),
                    ],
                  ),
                ],
              ),
              if (widget.product.isActive == false)
                Container(
                  width: double.infinity,
                  height: 260,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Center(
                    child: Text(
                      Languages.selectedLanguage == 0
                          ? "المنتج غير متوفر"
                          : 'widget.product not available',
                      style: TextStyle(
                          color: Colors.white, fontFamily: fonts, fontSize: 16),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
