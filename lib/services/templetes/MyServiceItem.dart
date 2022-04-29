import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/helpers/font.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/services/model/Order.dart';
import 'package:new_sahla/services/screens/OrderScreen.dart';
import 'package:provider/provider.dart';

class MyServiceItem extends StatefulWidget {
  MyServiceItem({
    this.order,
    Key key,
  }) : super(key: key);
  Order order;

  @override
  State<MyServiceItem> createState() => _MyServiceItemState();
}

class _MyServiceItemState extends State<MyServiceItem> {
  bool isLoadingSections = false;

  Map<String, Color> color = {
    'pending': Colors.yellow,
    'accept': Colors.greenAccent,
    'delay': Colors.deepOrange,
    'preview': Colors.purpleAccent,
    'start': Colors.deepPurple,
    'finished': Colors.lightBlueAccent,
    'reject': Colors.red,
  };

  Map<String, String> STATUS = {
    'pending': 'PENDING',
    'accept': 'ACCEPT',
    'delay': 'DELAY',
    'preview': 'PREVIEW',
    'start': 'START',
    'finished': 'FINISHED',
    'reject': 'REJECT',
  };

  Map<String, IconData> icons = {
    'pending': Icons.pending,
    'accept': Icons.check,
    'delay': Icons.history,
    'preview': Icons.remove_red_eye,
    'start': Icons.playlist_add_check_sharp,
    'finished': Icons.done_all,
    'reject': Icons.delete_sweep_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final lang = Provider.of<Languages>(context);
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 4, bottom: 4),
      decoration: BoxDecoration(
        // color: Colors.blueGrey,
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: Stack(
        children: [
          Card(
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(150)),
            child: InkWell(
              borderRadius: BorderRadius.circular(150),
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => OrderScreen(order: widget.order),
                    ));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      // padding:  EdgeInsets.only(right:8.0,
                      //     ),
                      width: mediaQuery.width * 0.62,
                      height: mediaQuery.height * 0.1,
                      // margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(''),
                                  Text(
                                    '${STATUS[widget.order.status]}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.red,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: fonts),
                                    textDirection: TextDirection.rtl,
                                  ),
                                ],
                              ),
                              Text(
                                '${widget.order.service.name}',
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: fonts),
                              ),
                              Expanded(
                                child: Text(
                                  '${widget.order.description}',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                      fontSize: 17,
                                      height: 1,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: fonts),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(150)),
                    child: CircleAvatar(
                      backgroundColor: widget.order.status == 'pending'
                          ? Colors.grey[300]
                          : Colors.greenAccent,
                      backgroundImage:
                          NetworkImage('${widget.order.service.image}'),
                      radius: 50,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Icon(
                  icons[widget.order.status],
                  color: color[widget.order.status],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
