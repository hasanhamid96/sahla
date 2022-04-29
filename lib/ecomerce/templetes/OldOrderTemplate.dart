import 'package:date_format/date_format.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import 'package:new_sahla/ecomerce/model/OrderModel.dart';
import 'package:new_sahla/ecomerce/model/productShow.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/providers/UserProvider.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/services/helpers/Rating.dart';
import 'package:new_sahla/services/helpers/toast_gf.dart';
import 'package:new_sahla/services/providers/Orders.dart';
import 'package:provider/provider.dart';

import 'ProductMainTemplateOrder.dart';

class OldOrderTemplate extends StatefulWidget {
  final OrderModel order;

  OldOrderTemplate({this.order});

  @override
  State<OldOrderTemplate> createState() => _OldOrderTemplateState();
}

class _OldOrderTemplateState extends State<OldOrderTemplate> {
  bool init = true;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (init)
      Future.delayed(Duration(milliseconds: 30)).then((value) {
        orderStatusWidgets = [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.orange,
                    radius: 12,
                  ),
                  Container(
                    height: 20,
                    child: VerticalDivider(
                      width: 12,
                      thickness: 2,
                      color: Colors.grey.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              Text(
                Languages.selectedLanguage == 0
                    ? "الطلب معلق"
                    : 'Order is Pending',
                style: Theme.of(context).textTheme.headline1,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 12,
                  ),
                  Container(
                    height: 20,
                    child: VerticalDivider(
                      width: 12,
                      thickness: 2,
                      color: Colors.grey.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              Text(
                Languages.selectedLanguage == 0
                    ? 'معالجة الطلب'
                    : 'Processing Order',
                style: Theme.of(context).textTheme.headline1,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.deepPurple,
                    radius: 12,
                  ),
                  Container(
                    height: 20,
                    child: VerticalDivider(
                      width: 12,
                      thickness: 2,
                      color: Colors.grey.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              Text(
                Languages.selectedLanguage == 0
                    ? "تسليم النظام"
                    : 'Delivering Order',
                style: Theme.of(context).textTheme.headline1,
              ),
            ],
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: 12,
                    child: Icon(
                      Icons.done,
                      color: Colors.white,
                    ),
                  ),
                ]),
              ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.deepPurple,
                    radius: 12,
                  ),
                  Container(
                    height: 20,
                    child: VerticalDivider(
                      width: 12,
                      thickness: 2,
                      color: Colors.grey.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              Text(
                Languages.selectedLanguage == 0 ? "تم التوصيل" : 'Delivered',
                style: Theme.of(context).textTheme.headline1,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.redAccent,
                    radius: 12,
                  ),
                ],
              ),
              Text(
                Languages.selectedLanguage == 0
                    ? "تم رفض الطلب"
                    : 'order Rejected',
                style: Theme.of(context).textTheme.headline1,
              ),
            ],
          ),
        ];
        setState(() {
          init = false;
        });
      });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void buildShowCupertinoDialog(context, Orders userPro, {orderId}) {
    var dir =
        Languages.selectedLanguage == 0 ? TextDirection.rtl : TextDirection.ltr;
    showCupertinoDialog(
      context: _scaffoldKey.currentContext,
      barrierDismissible: true,
      builder: (ctx) => CupertinoAlertDialog(
        insetAnimationCurve: Curves.easeInOutBack,
        content: Text(
          orderId != null
              ? Languages.selectedLanguage == 0
                  ? "هل تريد تأكيد الطلب؟"
                  : 'do you want to Confirm order?'
              : Languages.selectedLanguage == 0
                  ? 'هل تريد إلغاء الطلب؟'
                  : 'do you want to Cancel order?',
          textDirection: dir,
          style: Theme.of(ctx).textTheme.headline3,
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(ctx);
            },
            child: Text(
              Languages.selectedLanguage == 0 ? 'لا' : 'no',
              textDirection: dir,
              style: TextStyle(
                  color: Colors.blue, fontFamily: fonts, fontSize: 16),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              if (orderId != null) {
                Navigator.of(ctx).pop();
                print('confirm order>>>>');
                userPro
                    .userApproval(
                        approval: 1,
                        time: DateTime.now(),
                        type: 'delivered done',
                        approvalType: 'store',
                        orderId: orderId)
                    .then((value) {
                  if (value) {
                    ToastGF.showInSnackBar('delivered done', ctx);
                  }
                });
              } else {
                userPro
                    .cancelOrder(orderId: widget.order.id, isFromProduct: true)
                    .then((value) {
                  print(value);
                  if (value) {
                    Navigator.pop(ctx);
                    // Future.delayed(Duration(milliseconds: 200)).then((value){
                    //   ToastGF.showMessage(context,
                    //       Languages.selectedLanguage == 0
                    //           ? '
                    //           : ' order canceled successfully',
                    //       );
                    //   Navigator.pushAndRemoveUntil(
                    //       context,
                    //       CupertinoPageRoute(
                    //         builder: (context) =>
                    //             NavBottomServiceBar(),
                    //       ),
                    //           (route) => false);});
                  } else
                    ToastGF.showError(
                      ctx,
                      Languages.selectedLanguage == 0
                          ? "الطلب لم يتم إلغاؤه"
                          : ' order not canceled ',
                    );
                }).catchError((onError) {
                  ToastGF.showError(
                      ctx,
                      Languages.selectedLanguage == 0
                          ? "الطلب لم يتم إلغاؤه"
                          : ' order not canceled ');
                });
                Navigator.of(ctx).pop();
              }
            },
            child: Text(
              orderId != null
                  ? Languages.selectedLanguage == 0
                      ? "تأكيد الآن"
                      : 'Confirm  now'
                  : Languages.selectedLanguage == 0
                      ? "إلغاء الطلب الآن"
                      : 'Cancel Order now',
              textDirection: dir,
              style: TextStyle(
                  color: Colors.black, fontFamily: fonts, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  int index = 0;

  Widget build(BuildContext context) {
    final allpro = Provider.of<AllProviders>(context, listen: true);
    var textTheme = Theme.of(context).textTheme.headline1;
    final lang = Provider.of<Languages>(context);
    // print(order.product_order[0].photo);
    var dir =
        Languages.selectedLanguage == 1 ? TextDirection.rtl : TextDirection.ltr;
    return Directionality(
      textDirection: dir,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          title: Text(
            lang.translation['orderDetails'][Languages.selectedLanguage],
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          actions: [
            if (widget.order.status == 'delivered')
              if (widget.order.rate == null || widget.order.rate == 0)
                IconButton(
                    icon: Icon(CupertinoIcons.star_fill),
                    onPressed: widget.order.id == null
                        ? null
                        : () {
                            print(widget.order.rate);
                            Rating.showRatingDialog(
                                context, widget.order.id.toString(),
                                isService: false, orderId: widget.order.id);
                          })
          ],
        ),
        body: init
            ? Center(child: CircularProgressIndicator.adaptive())
            : SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        if (widget.order.status == 'pending')
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: Container(
                                  width: double.infinity,
                                  height: 80,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(colors: [
                                        Color.fromRGBO(22, 165, 231, 0.5),
                                        Color.fromRGBO(22, 165, 231, 1),
                                      ])),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        child: LoadingIndicator(
                                          indicatorType:
                                              Indicator.ballClipRotateMultiple,
                                          colors: const [Colors.white],
                                          backgroundColor: Colors.white,
                                        ),
                                      ),
                                      Text(
                                          lang.translation['waitingForProcess']
                                              [Languages.selectedLanguage],
                                          style: textTheme,
                                          textDirection: TextDirection.rtl),
                                    ],
                                  )),
                            ),
                          ),
                        //cancel order
                        if (widget.order.status == 'pending')
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              elevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      Languages.selectedLanguage == 0
                                          ? 'الغاء الطلب:'
                                          : 'cancel order:',
                                      style:
                                          Theme.of(context).textTheme.headline1,
                                      textDirection: TextDirection.rtl,
                                    ),
                                    Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            gradient: LinearGradient(colors: [
                                              Color.fromRGBO(231, 22, 22,
                                                  0.5019607843137255),
                                              Color.fromRGBO(252, 96, 96, 1.0),
                                            ])),
                                        child: RaisedButton(
                                          onPressed: () {
                                            return buildShowCupertinoDialog(
                                              context,
                                              Provider.of<Orders>(context,
                                                  listen: false),
                                            );
                                          },
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(7)),
                                          color: Colors.transparent,
                                          elevation: 0,
                                          highlightElevation: 0,
                                          disabledElevation: 0,
                                          focusElevation: 0,
                                          child: Text(
                                            Languages.selectedLanguage == 0
                                                ? "اضغط لإلغاء الطلب"
                                                : 'press to cancel order',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: fonts,
                                                fontSize: 20),
                                            textDirection: TextDirection.rtl,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        //order details
                        Card(
                          elevation: 0,
                          margin: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Container(
                            margin: EdgeInsets.all(20),
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment:
                                  Languages.selectedLanguage == 0
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  lang.translation['orderDetails']
                                      [Languages.selectedLanguage],
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontFamily: fonts),
                                  textAlign: Languages.selectedLanguage == 0
                                      ? TextAlign.right
                                      : TextAlign.left,
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundImage:
                                          UserProvider.userImage != null
                                              ? NetworkImage(
                                                  '${UserProvider.userImage}')
                                              : null,
                                      radius: 30,
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Order id : #${widget.order.id}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: fonts,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        Text(
                                          "Data : ${formatDate(DateTime.parse(widget.order.created_at), [
                                                yyyy,
                                                '/',
                                                mm,
                                                '/',
                                                dd,
                                                ' '
                                              ])}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: fonts,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            AllProviders.currency +
                                                " ${allpro.numToString(num.parse(widget.order.total).toStringAsFixed(0).toString())}",
                                            style: TextStyle(
                                                fontSize: 23,
                                                fontFamily: fonts,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Text(
                                  lang.translation['orderAddress']
                                      [Languages.selectedLanguage],
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontFamily: fonts),
                                ),
                                Divider(),
                                Text(
                                  "${widget.order.point}",
                                  style: Theme.of(context).textTheme.headline1,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  lang.translation['orderProducts']
                                      [Languages.selectedLanguage],
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontFamily: fonts),
                                ),
                                SizedBox(
                                  //  width: MediaQuery.of(context).size.width / 1.1,
                                  height: 290,
                                  child: ListView.builder(
                                    itemCount:
                                        widget.order.product_order.length,
                                    padding: EdgeInsets.all(10),
                                    scrollDirection: Axis.horizontal,
                                    reverse: Languages.selectedLanguage == 0
                                        ? true
                                        : false,
                                    itemBuilder: (ctx, index) {
                                      return Container(
                                        margin: EdgeInsets.only(
                                            right: 10, left: 10),
                                        child: ProductMainTemplateOrder(
                                          product: ProductShow(
                                            id: widget
                                                .order
                                                .product_order[index]
                                                .product_id,
                                            discount: 0,
                                            index: index,
                                            image: widget.order
                                                .product_order[index].photo,
                                            title: widget.order
                                                .product_order[index].name,
                                            price: num.parse(widget.order
                                                .product_order[index].price),
                                          ),
                                          isMain: false,
                                        ),
                                      );
                                    },
                                    //physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                  ),
                                ),
                                Divider(),
                                // Column(
                                //     children: order.product_order.map((product) {
                                //   Color color;
                                //   //print(product.color_code.toString());
                                //   if (product.color_code == null ||
                                //       product.color_code == "#No Color") {
                                //     color = null;
                                //   } else {
                                //     final hexCode =
                                //         product.color_code.replaceAll('#', '');
                                //     color = Color(int.parse('FF$hexCode', radix: 16));
                                //   }
                                //   return Column(
                                //     children: <Widget>[
                                //       Column(
                                //         children: <Widget>[
                                //           Text(
                                //             "${product.name} X ${product.quantity}",
                                //             textAlign: TextAlign.center,
                                //             style: TextStyle(fontSize: 18),
                                //           ),
                                //           SizedBox(
                                //             height: 7,
                                //           ),
                                //           color != null
                                //               ? CircleAvatar(
                                //                   radius: 5,
                                //                   backgroundColor: color,
                                //                 )
                                //               : SizedBox(
                                //                   height: 7,
                                //                 ),
                                //           Container(
                                //             decoration: BoxDecoration(
                                //               // boxShadow: <BoxShadow>[
                                //               //   BoxShadow(
                                //               //     color: Colors.grey.withOpacity(0.9),
                                //               //     spreadRadius: 0.5,
                                //               //     blurRadius: 1.5,
                                //               //   ),
                                //               // ],
                                //               shape: BoxShape.rectangle,
                                //               borderRadius:
                                //                   BorderRadius.all(Radius.circular(4)),
                                //               border: Border.all(
                                //                 color: Colors.grey.withOpacity(0.04),
                                //                 width: 2,
                                //               ),
                                //             ),
                                //             child: Center(
                                //               child: Container(
                                //                 padding: EdgeInsets.only(
                                //                     top: 8, left: 5, right: 5),
                                //                 decoration: BoxDecoration(
                                //                     color: Colors.white,
                                //                     shape: BoxShape.rectangle),
                                //                 child: Center(
                                //                   child: Text(
                                //                     product.size,
                                //                     style: TextStyle(fontSize: 19),
                                //                     textAlign: TextAlign.center,
                                //                   ),
                                //                 ),
                                //               ),
                                //             ),
                                //           ),
                                //           // Text(
                                //           //   "${}",
                                //           //   style: TextStyle(fontSize: 18),
                                //           // ),
                                //         ],
                                //       ),
                                //       Divider(
                                //         color: Theme.of(context).primaryColor,
                                //         thickness: 1,
                                //         endIndent: 100,
                                //         indent: 100,
                                //       )
                                //     ],
                                //   );
                                // }).toList()),
                                SizedBox(
                                  height: 10,
                                ),
                                // AddressOrderTemplate(),
                              ],
                            ),
                          ),
                        ),
                        if (widget.order.status != 'delivered')
                          Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              // border: Border(
                              //   top: BorderSide(
                              //     color: Colors.grey.withOpacity(0.3),
                              //     width: 2,
                              //   ),
                              // ),
                            ),
                            child: Column(
                              crossAxisAlignment:
                                  Languages.selectedLanguage == 0
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  lang.translation['FollowOrder']
                                      [Languages.selectedLanguage],
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontFamily: fonts),
                                ),
                                Divider(),
                                Container(
                                  margin: EdgeInsets.only(top: 10, left: 10),
                                  width: MediaQuery.of(context).size.width,
                                  child: Directionality(
                                    textDirection:
                                        Languages.selectedLanguage == 0
                                            ? TextDirection.rtl
                                            : TextDirection.ltr,
                                    child: Column(
                                        children: buildOrderStatus(
                                                widget.order.status)
                                            .toList()
                                        //here is the Item should be TODO
                                        ),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Text(
                                  lang.translation['moreDetails']
                                      [Languages.selectedLanguage],
                                  style: Theme.of(context).textTheme.headline1,
                                ),
                                Divider(),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  widget.order.message != null
                                      ? "${widget.order.message}"
                                      : "",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: fonts,
                                      color: Colors.redAccent),
                                  textDirection: TextDirection.rtl,
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                              ],
                            ),
                          ),
                        if (widget.order.status == 'delivered' &&
                            widget.order.approval_order == null)
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.lightBlueAccent,
                            ),
                            child: FlatButton(
                                onPressed: () {
                                  var userPro = Provider.of<Orders>(context,
                                      listen: false);
                                  userPro
                                      .userApproval(
                                          approval: 1,
                                          time: DateTime.now(),
                                          type: 'delivered done',
                                          approvalType: 'store',
                                          ctx: context,
                                          orderId: widget.order.id)
                                      .then((value) {
                                    if (value) {
                                      ToastGF.showInSnackBar(
                                          'delivered done', context);
                                    }
                                  });
                                  // return   buildShowCupertinoDialog(context,
                                  //     Provider.of<Orders>(context, listen: false),
                                  //     orderId:widget.order.id );
                                },
                                child: Text(
                                  Languages.selectedLanguage == 1
                                      ? 'Confirm receipt of order'
                                      : "تأكيد استلام الطلب",
                                  style: Theme.of(context).textTheme.headline2,
                                )),
                            height: 70,
                          ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  List<Widget> orderStatusWidgets = [];

  bool once = true;

  List<Widget> buildOrderStatus(String orderStatus) {
    buildList = [];
    if (orderStatus == "order is rejected") {
      buildList.add(orderStatusWidgets[4]);
      return buildList;
    }
    if (orderStatus == "pending") {
      for (var i = 0; i < orderStatusWidgets.length; i++) {
        buildList.add(orderStatusWidgets[i]);
        if (i == 0) {
          break;
        }
      }
    }
    if (orderStatus == "processing order") {
      for (var i = 0; i < orderStatusWidgets.length; i++) {
        buildList.add(orderStatusWidgets[i]);
        if (i == 1) {
          break;
        }
      }
    }
    if (orderStatus == "delivering order") {
      for (var i = 0; i < orderStatusWidgets.length; i++) {
        buildList.add(orderStatusWidgets[i]);
        if (i == 2) {
          break;
        }
      }
    }
    if (orderStatus == "delivered") {
      for (var i = 0; i < orderStatusWidgets.length; i++) {
        buildList.add(orderStatusWidgets[i]);
        if (i == 3) {
          break;
        }
      }
    }
    return buildList;
  }

  List<Widget> buildList = [];
}
