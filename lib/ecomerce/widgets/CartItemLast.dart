import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/model/cartItemModel.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/providers/UserProvider.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:provider/provider.dart';

class CartItemLast extends StatefulWidget {
  final CartItemModel cartItem;

  CartItemLast(this.cartItem);

  @override
  State<CartItemLast> createState() => _CartItemLastState();
}

class _CartItemLastState extends State<CartItemLast> {
  bool isUsingPoints = false;

  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    ScaffoldMessenger.of(context)?.removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      behavior: SnackBarBehavior.floating,
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

  @override
  Widget build(BuildContext context) {
    final mediaQ = MediaQuery.of(context).size;
    final allpro = Provider.of<AllProviders>(context);
    return Column(
      children: <Widget>[
        Container(
          // margin: EdgeInsets.only(bottom: 15),
          height: 160,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 0.2,
                  blurRadius: 1.9)
            ],
            border: Border(
              top: BorderSide(
                color: Theme.of(context).primaryColor.withOpacity(0.4),
                width: 0.8,
              ),
            ),
            // borderRadius: BorderRadius.all(
            //   Radius.circular(6),
            // ),
          ),
          child: Container(
            alignment: Alignment.centerRight,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // crossAxisAlignment: CrossAxisAlignment.s,
                    children: <Widget>[
                      Container(
                        width: mediaQ.width * 0.9,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Opacity(
                                  opacity: isUsingPoints ? 0 : 1,
                                  child: Text(
                                    '${allpro.numToString(widget.cartItem.price.toString())} ${AllProviders.currency}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: fonts,
                                        color: Colors.black45,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      widget.cartItem.name,
                                      textAlign: TextAlign.right,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: fonts,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      allpro.numToString(
                                          widget.cartItem.quantity.toString()),
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: fonts,
                                          color: Colors.lightBlueAccent,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              width: mediaQ.width * 0.9,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    // decoration: BoxDecoration(
                                    //   shape: BoxShape.rectangle,
                                    //   borderRadius: BorderRadius.all(Radius.circular(4)),
                                    //   border: Border.all(
                                    //     color: Colors.grey.withOpacity(0.1),
                                    //     width: 2,
                                    //   ),
                                    // ),
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          top: 8, left: 5, right: 5),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.rectangle),
                                      child: Text(
                                        widget.cartItem.size,
                                        style: TextStyle(
                                            fontFamily: fonts,
                                            fontSize: 12,
                                            color: Colors.black38),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.grey.withOpacity(0.1),
                                        width: 4,
                                      ),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color(int.parse(widget
                                                      .cartItem.color_code !=
                                                  "No Color"
                                              ? "0xff${widget.cartItem.color_code.replaceAll("#", "")}"
                                              : "0xffffffff")),
                                          shape: BoxShape.circle),
                                      child: SizedBox(
                                        height: 10,
                                        width: 10,
                                      ),
                                    ),
                                  ),
                                  // Container(
                                  //   padding: EdgeInsets.only(top: 8, left: 5, right: 5),
                                  //   decoration: BoxDecoration(
                                  //       color: Colors.white, shape: BoxShape.rectangle),
                                  //   child: Center(
                                  //       child: Text(
                                  //     "${widget.cartItem.quantity} X",
                                  //     style: TextStyle(fontSize: 13),
                                  //     textAlign: TextAlign.center,
                                  //   )),
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if(widget.cartItem.points>0)
                            Row(
                              children: [
                                CupertinoSwitch(
                                  activeColor: Theme.of(context).primaryColor,
                                  value: isUsingPoints,
                                  onChanged: (value) {
                                    print(widget.cartItem.points);
                                    print(UserProvider.points);
                                    if (widget.cartItem.points <=
                                        int.parse(UserProvider.points)) {
                                      setState(() {
                                        isUsingPoints = !isUsingPoints;
                                        // if( widget.cartItem.isUsePoint==null||!widget.cartItem.isUsePoint) {
                                        //   widget.cartItem.isUsePoint = true;
                                        //   RepositoryServiceTodo.updateCartPoint(
                                        //       widget.cartItem,
                                        //       isUsePoint:true);
                                        // }else {
                                        //   widget.cartItem.isUsePoint = false;
                                        //   RepositoryServiceTodo.updateCartPoint(
                                        //       widget.cartItem,
                                        //      isUsePoint: false);
                                        // }
                                        allpro.changeTotal(
                                            isUsingPoints,
                                            widget.cartItem.price *
                                                widget.cartItem.quantity,
                                            widget.cartItem.points);
                                      });
                                    } else
                                      showInSnackBar(
                                        Languages.selectedLanguage == 0
                                            ? "ليس لديك نقاط كافية"
                                            : "you do not have enough points",
                                      );
                                  },
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  Languages.selectedLanguage == 0
                                      ? 'نقطة'
                                      : 'point' +
                                          ' ' +
                                          '${widget.cartItem.points}',
                                  style: TextStyle(
                                      fontFamily: fonts,
                                      color: isUsingPoints
                                          ? Theme.of(context).primaryColor
                                          : Colors.black38),
                                )
                              ],
                            ),
                            Container(
                              width: mediaQ.width * 0.7,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('',
                                      style: TextStyle(
                                          fontFamily: fonts,
                                          color: isUsingPoints
                                              ? Theme.of(context).primaryColor
                                              : Colors.black38)),
                                  RotatedBox(
                                      quarterTurns: 2,
                                      child: Icon(Icons.arrow_right_alt_sharp,
                                          color: isUsingPoints
                                              ? Theme.of(context).primaryColor
                                              : Colors.black38))
                                ],
                              ),
                            )
                          ])
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
