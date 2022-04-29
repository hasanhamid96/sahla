import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/helpers/app_themes.dart';
import 'package:new_sahla/ecomerce/helpers/ecommerce_icons_icons.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/providers/RepositoryServiceTodo.dart';
import 'package:new_sahla/ecomerce/templetes/address_order_template.dart';
import 'package:new_sahla/ecomerce/widgets/CartItemLast.dart';
import 'package:new_sahla/ecomerce/widgets/OrderDeleted.dart';
import 'package:new_sahla/ecomerce/widgets/OrderDone.dart';
import 'package:new_sahla/ecomerce/widgets/OrderError.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert';

import 'PaymentSecondPayAddress.dart';

TextEditingController myController = TextEditingController();
final GlobalKey<ScaffoldState> _scaffoldKey2 = GlobalKey<ScaffoldState>();
double buttonWidth = 1.1;
bool isLoading = false;
bool isLoadingPromo = false;

class PaymentThirdConfirm extends StatefulWidget {
  PageController c;
  final PageController controller;

  PaymentThirdConfirm({this.c, this.controller});

  @override
  State<PaymentThirdConfirm> createState() => _PaymentThirdConfirmState();
}

class _PaymentThirdConfirmState extends State<PaymentThirdConfirm> {
  bool isnotThere = false;

  num totalInIqd = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final allpro = Provider.of<AllProviders>(context, listen: true);
    final lang = Provider.of<Languages>(context);
    final mediaQ = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey2,
      body: Container(
        // height: MediaQuery.of(context).size.height *1.2,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text(
                lang.translation['ConfirmeDate'][Languages.selectedLanguage],
                style: TextStyle(
                    fontFamily: fonts,
                    color: Theme.of(context).primaryColor,
                    fontSize: 19),
              ),
              Divider(
                endIndent: 100,
                indent: 100,
              ),
              Container(
                alignment: Alignment.topRight,
                width: mediaQ.width,
                // margin: EdgeInsets.only(right: 20,left: 20),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 0.2,
                          offset: Offset(0, 5),
                          blurRadius: 0.9)
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        EcommerceIcons.shopping_basket,
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ),
                      Text(
                        lang.translation['cartTitle']
                            [Languages.selectedLanguage],
                        style: TextStyle(
                            fontFamily: fonts,
                            color: Theme.of(context).primaryColor,
                            fontSize: 19),
                      ),
                    ],
                  ),
                ),
              ),
              Consumer<AllProviders>(
                builder: (ctx, data, _) {
                  return Column(
                    children: data.cartItemsAll.map((item) {
                      return CartItemLast(item);
                    }).toList(),
                  );
                },
              ),
              Container(
                alignment: Alignment.centerRight,
                width: MediaQuery.of(context).size.width,
                // margin: EdgeInsets.only(right: 20,left: 20),
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).primaryColor.withOpacity(0.4),
                        width: 0.8,
                      ),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 0.2,
                          offset: Offset(0, 5),
                          blurRadius: 0.9)
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        EcommerceIcons.placeholder,
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ),
                      Text(
                        lang.translation['shippingAddressTitle']
                            [Languages.selectedLanguage],
                        style: TextStyle(
                            fontFamily: fonts,
                            color: Theme.of(context).primaryColor,
                            fontSize: 19),
                      ),
                    ],
                  ),
                ),
              ),
              AddressOrderTemplate(allpro.selectedAddress, false),
              Container(
                alignment: Alignment.centerRight,
                width: MediaQuery.of(context).size.width,
                // margin: EdgeInsets.only(right: 20,left: 20),
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).primaryColor.withOpacity(0.4),
                        width: 0.8,
                      ),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 0.2,
                          offset: Offset(0, 5),
                          blurRadius: 0.9)
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        EcommerceIcons.money,
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ),
                      Text(
                        lang.translation['finalPrice']
                            [Languages.selectedLanguage],
                        style: TextStyle(
                            fontFamily: fonts,
                            color: Theme.of(context).primaryColor,
                            fontSize: 19),
                      ),
                    ],
                  ),
                ),
              ),
              //promocode
              Card(
                margin: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0)),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            topRight: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                          )),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 13.2, horizontal: 5),
                            child: Center(
                                child: isLoadingPromo == false
                                    ? Text(
                                        lang.translation['Confirmation']
                                            [Languages.selectedLanguage],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      )
                                    : CircularProgressIndicator(
                                        backgroundColor: Colors.white,
                                        strokeWidth: 1,
                                      )),
                          ),
                          onPressed: () {
                            setState(() {
                              isLoadingPromo = true;
                            });
                            allpro
                                .getPromocodes(myController.text)
                                .then((value) {
                              isnotThere = false;
                              print(value.amount);
                              print(value.product_id);
                              List<int> ids = [];
                              if (value.product_id != null) {
                                allpro.cartItemsAll.forEach((element) {
                                  ids.add(element.product_id);
                                });
                                if (ids.contains(value.product_id)) {
                                  isnotThere = false;
                                } else {
                                  isnotThere = true;
                                }
                              }
                              if (value.amount == "0" || isnotThere) {
                                showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return AlertDialog(
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Icon(
                                            Icons.warning,
                                            color: Colors.red,
                                          ),
                                          Text(
                                            lang.translation['CantApplyPromo']
                                                [Languages.selectedLanguage],
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4,
                                          ),
                                        ],
                                      ),
                                      elevation: 2,
                                    );
                                  },
                                );
                              } else {
                                int checker = allpro.calcuatePromocode(
                                    value.amount,
                                    value.product_id,
                                    allpro.cartItemsAll);
                                print(checker);
                                if (checker == 1) {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) {
                                      return AlertDialog(
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Icon(
                                              Icons.check_circle_outline,
                                              color: Colors.green,
                                            ),
                                            Text(
                                              lang.translation[
                                                      'promocodeCorrect']
                                                  [Languages.selectedLanguage],
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4,
                                            ),
                                          ],
                                        ),
                                        elevation: 2,
                                      );
                                    },
                                  );
                                } else if (checker == 0) {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) {
                                      return AlertDialog(
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Icon(
                                              Icons.warning,
                                              color: Colors.red,
                                            ),
                                            Text(
                                              lang.translation['CantApplyPromo']
                                                  [Languages.selectedLanguage],
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4,
                                            ),
                                          ],
                                        ),
                                        elevation: 2,
                                      );
                                    },
                                  );
                                }
                              }
                            }).then((value) {
                              setState(() {
                                isLoadingPromo = false;
                              });
                            });
                          },
                        ),
                        Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .bottomAppBarColor
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                          width: MediaQuery.of(context).size.width / 1.4,
                          child: TextField(
                            controller: myController,
                            onSubmitted: (value) {
                              //appProvider.search(value, context);
                            },
                            onChanged: (value) {
                              if (value == "") {
                                // appProvider.search(value, context);
                              }
                            },
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            decoration: new InputDecoration(
                                contentPadding: EdgeInsets.only(right: 10),
                                border: InputBorder.none,
                                hintText: lang.translation['promocode']
                                    [Languages.selectedLanguage],
                                hintStyle: TextStyle(
                                  color: Theme.of(context).bottomAppBarColor,
                                ),
                                labelStyle: TextStyle(fontSize: 23),
                                suffixStyle: TextStyle(
                                    color: Theme.of(context).primaryColor)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Column(
                        children: <Widget>[
                          //subTotal Price
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "${allpro.numToString(allpro.lastTotalPrice.toString())}" +
                                    ' ' +
                                    AllProviders.currency,
                                style: TextStyle(
                                  fontFamily: fonts,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .color,
                                ),
                              ),
                              Text(
                                lang.translation['price']
                                    [Languages.selectedLanguage],
                                style: TextStyle(
                                    fontFamily: fonts,
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .color,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          //delivery
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                allpro.numToString(
                                    allpro.shippingCost.toString()),
                                style: TextStyle(
                                  fontFamily: fonts,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .color,
                                ),
                              ),
                              Text(
                                lang.translation['delivery']
                                    [Languages.selectedLanguage],
                                style: TextStyle(
                                    fontFamily: fonts,
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .color,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          //discount
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                allpro.promocode.amount != "0" &&
                                        isnotThere == false
                                    ? allpro.numToString(
                                        allpro.promocode.amount.toString())
                                    : "0",
                                style: TextStyle(
                                  fontFamily: fonts,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .color,
                                ),
                              ),
                              Text(
                                lang.translation['discount']
                                    [Languages.selectedLanguage],
                                style: TextStyle(
                                    fontFamily: fonts,
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .color,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                          Divider(
                            endIndent: 100,
                            indent: 100,
                          ),
                          //total in USD
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                allpro.numToString(allpro.lastlastTotalPrice
                                    .toStringAsFixed(0)),
                                style: TextStyle(
                                  fontFamily: fonts,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .color,
                                ),
                                textAlign: TextAlign.right,
                              ),
                              Text(
                                lang.translation['total']
                                    [Languages.selectedLanguage],
                                style: TextStyle(
                                    fontFamily: fonts,
                                    fontSize: 14,
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .color,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                          Divider(
                            endIndent: 100,
                            indent: 100,
                          ),
                          //total in IQD
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                allpro.numToString(
                                    allpro.totalIraqi.toStringAsFixed(0)),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: fonts,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .color,
                                ),
                                textAlign: TextAlign.right,
                              ),
                              Text(
                                Languages.selectedLanguage == 0
                                    ? "الإجمالي بالدينار العراقي:"
                                    : "total in IQD :",
                                style: Theme.of(context).textTheme.headline1,
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    // FittedBox(
                    //   fit: BoxFit.cover,
                    //   child: Center(
                    //     child: Card(
                    //       elevation: 0,
                    //       color: Color.fromRGBO(223, 248, 245, 1),
                    //       shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(20)
                    //       ),
                    //       child: Padding(
                    //         padding: const EdgeInsets.symmetric(
                    //             vertical: 5, horizontal: 18),
                    //         child: Row(
                    //           mainAxisSize: MainAxisSize.min,
                    //           children: [
                    //             Image.asset(
                    //               'assets/images/iconbanner.png',
                    //               width: 20,
                    //               height: 20,
                    //             ),
                    //             SizedBox(width: 5,),
                    //             Text(
                    //               '
                    // ${allpro
                    //                   .totalPoints}',
                    //               style:
                    //               Theme
                    //                   .of(context)
                    //                   .textTheme
                    //                   .headline1,
                    //               textDirection: TextDirection.rtl,
                    //             ),
                    //
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: MediaQuery.of(context).size.width / buttonWidth,
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: isLoading == false
                        ? Text(
                            lang.translation['confirmeTheBut']
                                [Languages.selectedLanguage],
                            style: TextStyle(
                                fontFamily: fonts,
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )
                        : CircularProgressIndicator(),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    buttonWidth = 2;
                    isLoading = true;
                  });
                  if (PaymentSecondPayAddress.radioItem == '1')
                    allpro.updatePoints();
                  allpro.sendOrder().then((value) {
                    buttonWidth = 1.1;
                    isLoading = false;
                    var jsonData = json.decode(value.body);
                    if (jsonData['status'] == false) {
                      String errorNoProduct = jsonData['msg'].toString();
                      if (errorNoProduct.contains("File not found")) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderDeleted(
                                controller: widget.controller,
                              ),
                            ));
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderError(
                              controller: widget.controller,
                            ),
                          ),
                        );
                      }
                    } else {
                      RepositoryServiceTodo.deleteAllCartItem().then((value) {
                        RepositoryServiceTodo.getAllCarts();
                        allpro.getOrders();
                        allpro.refreshCartItem(0);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderDone(
                                controller: widget.controller,
                              ),
                            ));
                      });
                    }
                  });
                },
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
