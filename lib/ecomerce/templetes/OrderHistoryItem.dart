
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/model/OrderModel.dart';
import 'package:provider/provider.dart';

import 'OldOrderTemplate.dart';
class OrderHistoryItem extends StatelessWidget {
  final OrderModel order;
  OrderHistoryItem({this.order});
  @override
  Color color;
  Widget build(BuildContext context) {
    if (order.status == "pending") {
      color = Colors.orange;
    } else if (order.status == "rejected") {
      color = Colors.redAccent;
    } else if (order.status == "delivered") {
      color = Colors.green;
    } else if (order.status == "delivering order") {
      color = Colors.yellow;
    } else if (order.status == "processing order") {
      color = Colors.brown;
    }
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OldOrderTemplate(order: order),
            ));
      },
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(6),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2.0,
                blurRadius: 8,
              ),
            ]
          // border: Border(
          //   bottom: BorderSide(
          //     color: Colors.grey.withOpacity(0.3),
          //     width: 2,
          //   ),
          // ),
        ),
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 10),
              child: CircleAvatar(
                backgroundColor: color,
                radius: 5,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Order #${order.id}",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${order.status}",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme
                          .of(context)
                          .primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  "view the ${order.product_order.length} items",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  formatDate(DateTime.parse(order.created_at),
                      [yyyy, '/', mm, '/', dd, ' ']),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }}