import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:like_button/like_button.dart';
import 'package:new_sahla/ecomerce/model/productShow.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/ecomerce/screens/pressedScreen/pressedProduct.dart';
import 'package:provider/provider.dart';

class ProductMainTemplateOrder extends StatefulWidget {
  final ProductShow product;
  final bool isMain;

  ProductMainTemplateOrder({@required this.product, @required this.isMain});

  @override
  State<ProductMainTemplateOrder> createState() =>
      _ProductMainTemplateOrderState();
}

class _ProductMainTemplateOrderState extends State<ProductMainTemplateOrder> {
  String imageName;

  @override
  void initState() {
    imageName = widget.product.image.split("/").last;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final allPro = Provider.of<AllProviders>(context, listen: false);
    //print(product.index);
    return InkWell(
      onTap: () {
        //setState(() {
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
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Stack(children: <Widget>[
                  CachedNetworkImage(
                    height: 135,
                    width: 200,
                    fit: BoxFit.contain,
                    fadeInCurve: Curves.bounceOut,
                    imageUrl: widget.product.image,
                    placeholder: (context, url) {
                      return Image.asset(
                        "assets/images/placeholder.png",
                        fit: BoxFit.contain,
                      );
                    },
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  // widget.product.discount != 0
                  //     ? Container(
                  //         padding: EdgeInsets.all(4),
                  //         margin: EdgeInsets.only(left: 10),
                  //         decoration: BoxDecoration(
                  //             color: Theme.of(context).accentColor,
                  //             borderRadius: BorderRadius.only(
                  //                 // bottomRight: Radius.circular(15),
                  //                 // topLeft: Radius.circular(10),
                  //                 )),
                  //         child: Text(
                  //           Languages.selectedLanguage == 1 ? "sale" : "
                  //           style: TextStyle(
                  //             fontSize: 15,
                  //             fontWeight: FontWeight.w600,
                  //             color: Colors.white,
                  //           ),
                  //         ),
                  //       )
                  //     : SizedBox(),
                ]),
              ),
              Container(
                padding: EdgeInsets.only(
                  top: 10,
                  left: 5,
                  right: 5,
                  bottom: 5,
                ),
                child: Text(
                  widget.product.title,
                  textDirection: Languages.selectedLanguage == 0
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black87, fontSize: 13),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(top: 10),
                      child: widget.product.discount == 0
                          ? Text(
                              "${allPro.numToString(widget.product.price.toString())}",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontFamily: 'tajawal',
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 21,
                                decorationThickness: 10,
                              ),
                              overflow: TextOverflow.ellipsis,
                            )
                          : Column(
                              children: [
                                Text(
                                  "${allPro.numToString(widget.product.discount.toString())}",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontFamily: 'tajawal',
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 21,
                                    decorationThickness: 10,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "${allPro.numToString(widget.product.price.toString())}",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontFamily: 'tajawal',
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17,
                                    decoration: TextDecoration.lineThrough,
                                    decorationThickness: 10,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            )),
                ],
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
