import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:new_sahla/ecomerce/helpers/font.dart';
import 'package:new_sahla/ecomerce/model/Product.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/templetes/SizeColorTemplate.dart';
import 'package:provider/provider.dart';

class ProductColorSizePressed extends StatefulWidget {
  final Product product;

  ProductColorSizePressed({this.product});

  static int quantityCounter = 1;

  @override
  State<ProductColorSizePressed> createState() => _ProductColorSizePressedState();
}

class _ProductColorSizePressedState extends State<ProductColorSizePressed> {
  @override
  Widget build(BuildContext context) {
    final allposts = Provider.of<AllProviders>(context, listen: true);
    final lang = Provider.of<Languages>(context);
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: Languages.selectedLanguage == 1
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            children: <Widget>[
              Languages.selectedLanguage == 1
                  ? Container(
                      child: Center(
                        child: Text(
                          lang.translation['quantityTitle']
                              [Languages.selectedLanguage],
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: fonts,
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                  : SizedBox(),
              Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 21,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        AllProviders.selectedPiece != null
                            ? Container(
                                width: 50,
                                height: 50,
                                child: SizeColorTemplate(
                                  context2: context,
                                  pieces: AllProviders.selectedPiece,
                                  isSelected: true,
                                ),
                              )
                            : SizedBox(),
                        allposts.allProduct.pieces.length != 0
                            ? Container(
                                margin: EdgeInsets.only(right: 6, left: 6),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: RaisedButton(
                                  color: Theme.of(context).primaryColor,
                                  child: Text(
                                    Languages.selectedLanguage == 0
                                        ? "حدد الحجم ، النوع"
                                        : "Select Size , type",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    AllProviders.isColorsNavigatorOpen = true;
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor:
                                              Colors.grey.withOpacity(0.4),
                                          title: Text(
                                            Languages.selectedLanguage == 0
                                                ? "حدد نوعًا واحدًا من الألوان والحجم والأنواع"
                                                : "Select one color and size , types",
                                            textAlign: TextAlign.center,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          content: SingleChildScrollView(
                                              child: Container(
                                            width: 100,
                                            height: 400,
                                            child: GridView.builder(
                                              itemCount: allposts
                                                  .allProduct.pieces.length,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 4,
                                                childAspectRatio: 1 / 1,
                                                crossAxisSpacing: 10,
                                                mainAxisSpacing: 15,
                                              ),
                                              itemBuilder: (ctx, index) {
                                                return SizeColorTemplate(
                                                  context2: context,
                                                  pieces: allposts
                                                      .allProduct.pieces[index],
                                                  isSelected: false,
                                                );
                                              },
                                              shrinkWrap: true,
                                            ),
                                          )),
                                          actions: [],
                                        );
                                      },
                                    );
                                  },
                                ),
                              )
                            : SizedBox(),
                        //     },
                        //   ),
                        Column(
                          children: [
                            Row(
                              children: <Widget>[
                                InkWell(
                                  onTap: AllProviders.selectedPiece == null
                                      ? () {
                                          setState(() {
                                            if (allposts.allProduct.quantity !=
                                            ProductColorSizePressed.quantityCounter) {
                                              ProductColorSizePressed
                                                  .quantityCounter++;
                                            }
                                          });
                                        }
                                      : () {
                                          setState(() {
                                            if (AllProviders
                                                    .selectedPiece.quantity !=
                                               ProductColorSizePressed.quantityCounter) {
                                              ProductColorSizePressed
                                                  .quantityCounter++;
                                            }
                                          });
                                        },
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Center(
                                      child: Text(
                                        "+",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                ProductColorSizePressed.quantityCounter
                                      .toString(),
                                  // AllProviders.selectedQuintity2.toString(),
                                  style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                InkWell(
                                  onTap: AllProviders.selectedPiece == null
                                      ? () {
                                          setState(() {
                                            if (ProductColorSizePressed.quantityCounter >
                                                1) {
                                              ProductColorSizePressed
                                                  .quantityCounter--;
                                            }
                                          });
                                        }
                                      : () {
                                          setState(() {
                                            if (ProductColorSizePressed.quantityCounter >
                                                1) {
                                              ProductColorSizePressed
                                                  .quantityCounter--;
                                            }
                                          });
                                        },
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Center(
                                      child: Text(
                                        "-",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            AllProviders.selectedPiece != null
                                ? Container(
                                    padding:
                                        EdgeInsets.only(right: 15, top: 13),
                                    child: Text(
                                      AllProviders.selectedPiece.quantity > 0
                                          ? "${lang.translation['remainsTitle'][Languages.selectedLanguage]} ${AllProviders.selectedPiece.quantity.toString()}"
                                          : "${lang.translation['outOfStock'][Languages.selectedLanguage]}",
                                      style: TextStyle(
                                          color: AllProviders
                                                      .selectedPiece.quantity >
                                                  0
                                              ? Colors.blueGrey
                                              : Colors.redAccent),
                                    ),
                                  )
                                : Text(
                                    '',
                                    // allposts.allProduct.quantity > 0
                                    //     ? "${lang.translation['remainsTitle'][Languages.selectedLanguage]} ${allposts.allProduct.quantity.toString()}"
                                    //     : "${lang.translation['outOfStock'][Languages.selectedLanguage]}",
                                    style: TextStyle(
                                        color: allposts.allProduct.quantity > 0
                                            ? Colors.blueGrey
                                            : Colors.redAccent),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Languages.selectedLanguage == 0
                  ? Container(
                      child: Center(
                        child: Text(
                          lang.translation['quantityTitle']
                              [Languages.selectedLanguage],
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontFamily: fonts,
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}
