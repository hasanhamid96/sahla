import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';

import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/providers/UserProvider.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/services/helpers/Rating.dart';
import 'package:new_sahla/services/helpers/helper_services.dart';
import 'package:new_sahla/services/helpers/toast_gf.dart';
import 'package:new_sahla/services/model/Order.dart';
import 'package:new_sahla/services/providers/Orders.dart';
import 'package:new_sahla/services/widgets/user_map_loc.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

import 'detail_service.dart';

class OrderScreen extends StatefulWidget {
  OrderScreen({
    this.order,
    Key key,
  }) : super(key: key);
  Order order;

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<Widget> orderStatusWidgets = [];

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    OneSignal.shared.setNotificationOpenedHandler((notification) {
      if (notification.notification.body == 'finished')
        showFinishStartMessage(
            context: context, isStart: false, orderId: widget.order.id);
      // else
      //   show_Finish_start_Message(
      //       context: context,
      //       isStart: false,
      //       orderId: widget.order.id,
      //       server_id: widget.order.server_id);
    });
  }

  Map<String, List<Widget>> ordersTrack = {};

  int duration = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    total();
    print(widget.order.status);
    if (widget.order.service_end != null) {
      duration = DateTime.parse(widget.order.service_end)
          .difference(DateTime.parse(widget.order.service_start))
          .inMinutes
          .abs();
    }
    ordersTrack = {
      'pending': [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 13.0),
              child: Column(
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
            ),
            Text(
                Languages.selectedLanguage == 0
                    ? "الطلب معلق"
                    : 'Order is PENDING',
                style: TextStyle(color: Colors.black45, fontFamily: fonts)),
          ],
        ),
      ],
      'accept': [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 13.0),
              child: Column(
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
            ),
            Text(
                Languages.selectedLanguage == 0
                    ? "الطلب معلق"
                    : 'Order is PENDING',
                style: TextStyle(color: Colors.black45, fontFamily: fonts)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 13.0),
              child: Column(
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
            ),
            Text(
                Languages.selectedLanguage == 0
                    ? "تم تعيين فني${widget.order.server_name}) "
                    : 'Technician Appointed (${widget.order.server_name})',
                style: TextStyle(color: Colors.black45, fontFamily: fonts)),
          ],
        ),
      ],
      'delay': [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 13.0),
              child: Column(
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
            ),
            Text(
                Languages.selectedLanguage == 0
                    ? "الطلب معلق"
                    : 'Order is PENDING',
                style: TextStyle(color: Colors.black45, fontFamily: fonts)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 13.0),
              child: Column(
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
            ),
            Text(
                Languages.selectedLanguage == 0
                    ? "تم تعيين فني(${widget.order.server_name}) "
                    : 'Technician Appointed (${widget.order.server_name})',
                style: TextStyle(color: Colors.black45, fontFamily: fonts)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 13.0),
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.deepOrange,
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
            ),
            Text(
                Languages.selectedLanguage == 0
                    ? "تم تأجيل العمل"
                    : 'work has been DELAYED',
                style: TextStyle(color: Colors.black45, fontFamily: fonts)),
          ],
        ),
      ],
      'preview': [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 13.0),
              child: Column(
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
            ),
            Text(
                Languages.selectedLanguage == 0
                    ? "الطلب معلق"
                    : 'Order is PENDING',
                style: TextStyle(color: Colors.black45, fontFamily: fonts)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 13.0),
              child: Column(
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
            ),
            Text(
                Languages.selectedLanguage == 0
                    ? "تم تعيين فني(${widget.order.server_name}) "
                    : 'Technician Appointed (${widget.order.server_name})',
                style: TextStyle(color: Colors.black45, fontFamily: fonts)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 13.0),
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.purpleAccent,
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
            ),
            Text(Languages.selectedLanguage == 0 ? "في معاينة" : 'IN PREVIEW',
                style: TextStyle(color: Colors.black45, fontFamily: fonts)),
          ],
        ),
      ],
      'start': [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 13.0),
              child: Column(
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
            ),
            Text(
                Languages.selectedLanguage == 0
                    ? "الطلب معلق"
                    : 'Order is PENDING',
                style: TextStyle(color: Colors.black45, fontFamily: fonts)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 13.0),
              child: Column(
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
            ),
            Text(
                Languages.selectedLanguage == 0
                    ? "تم تعيين فني  (${widget.order.server_name}) "
                    : 'Technician Appointed (${widget.order.server_name})',
                style: TextStyle(color: Colors.black45, fontFamily: fonts)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 13.0),
              child: Column(
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
            ),
            Text(
                Languages.selectedLanguage == 0
                    ? "تم بدء العمل"
                    : 'work has been STARTED',
                style: TextStyle(color: Colors.black45, fontFamily: fonts)),
          ],
        ),
      ],
      'finished': [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 13.0),
              child: Column(
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
            ),
            Text(
                Languages.selectedLanguage == 0
                    ? 'الطلب معلق'
                    : 'Order is PENDING',
                style: TextStyle(color: Colors.black45, fontFamily: fonts)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 13.0),
              child: Column(
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
            ),
            Text(
                Languages.selectedLanguage == 0
                    ? "تم تعيين فني(${widget.order.server_name}) "
                    : 'Technician Appointed (${widget.order.server_name})',
                style: TextStyle(color: Colors.black45, fontFamily: fonts)),
          ],
        ),
        if (widget.order.status_date != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 13.0),
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.deepOrange,
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
              ),
              Text(
                  Languages.selectedLanguage == 0
                      ? "تم تأجيل العمل ${widget.order.status_date} "
                      : 'Work Has Been DELAYED ${widget.order.status_date}',
                  style: TextStyle(color: Colors.black45, fontFamily: fonts)),
            ],
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 13.0),
              child: Column(
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
            ),
            Text(
                Languages.selectedLanguage == 0
                    ? "بدأ العمل"
                    : 'Work Has Been STARTED',
                style: TextStyle(color: Colors.black45, fontFamily: fonts)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 13.0),
              child: CircleAvatar(
                backgroundColor: Colors.green,
                radius: 12,
                child: Icon(
                  Icons.done,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
                Languages.selectedLanguage == 0 ? "تم الانتهاء من" : 'FINISHED',
                style: TextStyle(color: Colors.black45, fontFamily: fonts)),
          ],
        ),
      ],
      'end': [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 13.0),
              child: Column(
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
            ),
            Text(
                Languages.selectedLanguage == 0
                    ? "الطلب معلق"
                    : 'Order is Pending',
                style: TextStyle(color: Colors.black45, fontFamily: fonts)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 13.0),
              child: Column(
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
            ),
            Text(
                Languages.selectedLanguage == 0
                    ? "فني معين (${widget.order.server_name}) "
                    : 'Technician appointed (${widget.order.server_name})',
                style: TextStyle(color: Colors.black45, fontFamily: fonts)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 13.0),
              child: Column(
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
            ),
            Text(
                Languages.selectedLanguage == 0
                    ? "تم وضع العمل"
                    : 'work has been statred',
                style: TextStyle(color: Colors.black45, fontFamily: fonts)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 13.0),
              child: CircleAvatar(
                backgroundColor: Colors.green,
                radius: 12,
                child: Icon(
                  Icons.done,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
                Languages.selectedLanguage == 0 ? "تم الانتهاء من" : 'Finished',
                style: TextStyle(color: Colors.black45, fontFamily: fonts)),
          ],
        ),
      ],
      'reject': [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 13.0),
              child: CircleAvatar(
                backgroundColor: Colors.red,
                radius: 12,
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
            Text(Languages.selectedLanguage == 0 ? "مرفوض " : 'REJECTED',
                style: TextStyle(color: Colors.black45, fontFamily: fonts)),
          ],
        ),
      ],
      // 'reject':Colors.red,
    };
  }

  Map<String, String> STATUS = {
    'pending': 'PENDING',
    'accept': 'ACCEPT',
    'delay': 'DELAY',
    'preview': 'PREVIEW',
    'start': 'START',
    'finished': 'FINISHED',
    'reject': 'REJECT',
  };

  void buildShowCupertinoDialog(BuildContext context, Orders userPro,
      {orderId}) {
    var dir = Languages.selectedLanguage == 0
        ? ui.TextDirection.rtl
        : ui.TextDirection.ltr;
    showDialog(
      context: _scaffoldKey.currentContext,
      // barrierDismissible: true,
      builder: (ctx) => CupertinoAlertDialog(
        insetAnimationCurve: Curves.easeInOutBack,
        content: Text(
          orderId != null
              ? Languages.selectedLanguage == 0
                  ? 'هل تريد تأكيد الطلب؟'
                  : 'do you want to Confirm order?'
              : Languages.selectedLanguage == 0
                  ? 'هل تريد إلغاء الطلب؟ '
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
                print('confirm order>>>>');
                userPro
                    .userApproval(
                        approval: 1,
                        time: DateTime.now(),
                        approvalType: 'service',
                        type: 'end',
                        orderId: orderId)
                    .then((value) {
                  if (value) {
                    ToastGF.showInSnackBar('confirmed order', context);
                    setState(() {
                      widget.order.service_end_user_approval = 'approved';
                    });
                  }
                });
              } else {
                userPro
                    .cancelOrder(orderId: widget.order.id, isFromProduct: false)
                    .then((value) {
                  print(value);
                  if (value) {
                    Navigator.pop(context);
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
                      context,
                      Languages.selectedLanguage == 0
                          ? 'الطلب لم يتم إلغاؤه'
                          : ' order not canceled ',
                    );
                }).catchError((onError) {
                  ToastGF.showError(
                    context,
                    Languages.selectedLanguage == 0
                        ? 'الطلب لم يتم إلغاؤه '
                        : ' order not canceled ',
                  );
                });
              }
              Navigator.of(context).pop();
            },
            child: Text(
              orderId != null
                  ? Languages.selectedLanguage == 0
                      ? 'أكد الآن'
                      : 'Confirm  now'
                  : Languages.selectedLanguage == 0
                      ? 'إلغاء الطلب الآن '
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  double subTotal = 0.0;

  double totalPrice = 0.0;

  void total() {
    setState(() {
      if (widget.order.service.inMinutes == 1)
        subTotal = (duration) * double.parse(widget.order.service.price);
      if (widget.order.service.inMinutes == 0)
        subTotal = double.parse(widget.order.service.price);
      if (widget.order.operator == 'add')
        totalPrice = subTotal + (widget.order.additionalPrice);
      if (widget.order.operator == 'subtract')
        totalPrice = subTotal - (widget.order.additionalPrice);
    });
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userPro = Provider.of<UserProvider>(context);
    final allPro = Provider.of<AllProviders>(context);
    var textTheme = Theme.of(context).textTheme.headline1;
    final proOrders = Provider.of<Orders>(context, listen: false);
    final lang = Provider.of<Languages>(context);
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              CupertinoIcons.back,
              size: 30,
            ),
            splashRadius: 20,
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          'Order',
          style: Theme.of(context).textTheme.headline2,
        ),
        actions: [
          if (widget.order.status == 'finished')
            if (widget.order.rate == 0.0)
              IconButton(
                  icon: Icon(CupertinoIcons.star_fill),
                  splashRadius: 20,
                  onPressed: widget.order.server_id == null
                      ? null
                      : () async {
                          await Rating.showRatingDialog(
                              context, widget.order.server_id.toString(),
                              orderId: widget.order.id);
                          setState(() {
                            // widget.order.rate=4.0;
                          });
                        }),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (widget.order.status == 'pending')
                Center(
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
                              indicatorType: Indicator.ballClipRotateMultiple,
                              colors: const [Colors.white],
                              backgroundColor: Colors.white,
                            ),
                          ),
                          Text(
                              lang.translation['waitingForProcess']
                                  [Languages.selectedLanguage],
                              style: textTheme,
                              textDirection: ui.TextDirection.rtl),
                        ],
                      )),
                ),
              //cancel order
              if (widget.order.status == 'pending')
                Padding(
                  padding: EdgeInsets.only(top: 10),
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
                            style: Theme.of(context).textTheme.headline1,
                            textDirection: ui.TextDirection.rtl,
                          ),
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  gradient: LinearGradient(colors: [
                                    Color.fromRGBO(
                                        231, 22, 22, 0.5019607843137255),
                                    Color.fromRGBO(252, 96, 96, 1.0),
                                  ])),
                              child: RaisedButton(
                                onPressed: () {
                                  buildShowCupertinoDialog(
                                      _scaffoldKey.currentContext, proOrders);
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7)),
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
                                  textDirection: ui.TextDirection.rtl,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              //invoice
              if (widget.order.status != 'pending')
                Card(
                  margin: EdgeInsets.all(3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 2,
                          ),
                          child: Text(
                            Languages.selectedLanguage == 1
                                ? 'General Info'
                                : 'معلومات عامة',
                            style: textTheme,
                            textDirection: ui.TextDirection.rtl,
                          ),
                        ),
                        Divider(),
                        Directionality(
                          textDirection: ui.TextDirection.rtl,
                          child: Table(
                            children: [
                              TableRow(children: [
                                Text(
                                  'رقم الفاتورة',
                                  style: textTheme,
                                ),
                                Text('SR-${widget.order.id}', style: textTheme),
                              ]),
                              TableRow(children: [
                                Text(
                                  ' تاريخ بدا الخدمة',
                                  style: textTheme,
                                ),
                                Text('${widget.order.service_start}',
                                    style: textTheme),
                              ]),
                              TableRow(children: [
                                Text(
                                  'انتهاء الخدمة:',
                                  style: textTheme,
                                ),
                                Text('${widget.order.service_end} ',
                                    style: textTheme),
                              ]),
                              TableRow(children: [
                                Text('status:', style: textTheme),
                                Text('${STATUS[widget.order.status]}',
                                    style: textTheme),
                              ]),
                              TableRow(children: [
                                Text('description:', style: textTheme),
                                Text('${widget.order.description}',
                                    style: textTheme),
                              ]),
                              if (widget.order.service_start != null)
                                TableRow(children: [
                                  Text(
                                    'server name',
                                    style: textTheme,
                                  ),
                                  Text('${widget.order.server_name}',
                                      style: textTheme),
                                ]),
                              TableRow(children: [
                                Text(
                                  'server phone',
                                  style: textTheme,
                                ),
                                Text('${widget.order.server_phone}',
                                    style: textTheme),
                              ]),
                              if (widget.order.status_date != null)
                                TableRow(children: [
                                  Text(
                                    'status date',
                                    style: textTheme,
                                  ),
                                  Text('${widget.order.status_date}',
                                      style: textTheme),
                                ]),
                              if (widget.order.status_description != null)
                                TableRow(children: [
                                  Text(
                                    'status description',
                                    style: textTheme,
                                  ),
                                  Text('${widget.order.status_description}',
                                      style: textTheme),
                                ]),
                              TableRow(children: [
                                Text('service price', style: textTheme),
                                Row(
                                  children: [
                                    Text(
                                        '${(allPro.numToString(widget.order.service.price))} ',
                                        style: textTheme),
                                    Text(
                                        widget.order.service.inMinutes == 1
                                            ? Languages.selectedLanguage == 0
                                                ? 'دينار / دقيقة'
                                                : 'IQD/min'
                                            : Languages.selectedLanguage == 0
                                                ? 'دينار '
                                                : 'IQD',
                                        style: textTheme),
                                  ],
                                )
                              ]),
                              if (widget.order.status == 'finished')
                                TableRow(children: [
                                  Text('duration', style: textTheme),
                                  Row(
                                    children: [
                                      Text(' $duration ', style: textTheme),
                                      Text(
                                          Languages.selectedLanguage == 0
                                              ? 'دقيقة'
                                              : 'min',
                                          style: textTheme),
                                    ],
                                  )
                                ]),
                              if (widget.order.status == 'finished')
                                TableRow(children: [
                                  Text(
                                    'subTotal',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: fonts),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                          '${allPro.numToString(subTotal.toString())}  ',
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: fonts)),
                                      Text(
                                          Languages.selectedLanguage == 0
                                              ? 'دينار عراقي'
                                              : 'IQD',
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: fonts)),
                                    ],
                                  ),
                                ]),
                              if (widget.order.status == 'finished' &&
                                  widget.order.operator != null)
                                TableRow(children: [
                                  Text(
                                    widget.order.operator == 'subtract'
                                        ? 'خصم :'
                                        : ' subtract:  ',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: fonts),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                          '${allPro.numToString(widget.order.additionalPrice.toString())} ${widget.order.operator == 'subtract' ? '-' : '+'}  ',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: fonts)),
                                      Text(
                                          Languages.selectedLanguage == 0
                                              ? 'دينار عراقي'
                                              : 'IQD',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: fonts)),
                                    ],
                                  ),
                                ]),
                              if (widget.order.operator != null)
                                TableRow(children: [
                                  Text(
                                    'totalPrice:',
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: fonts),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                          '${allPro.numToString(totalPrice.toString())}  ',
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: fonts)),
                                      Text(
                                          Languages.selectedLanguage == 0
                                              ? 'دينار عراقي'
                                              : 'IQD',
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: fonts)),
                                    ],
                                  ),
                                ]),
                              // if (widget.order.status == 'finished')
                              //   TableRow(children: [
                              //     Text('
                              //         style: textTheme),
                              //     Row(
                              //       children: [
                              //         if(widget.order.service.inMinutes==1)
                              //         Text(
                              //             '${int.parse(duration.toString()) * double.parse(widget.order.service.price)}',
                              //             style: TextStyle(color: Colors.blue,fontFamily: fonts,fontSize: 17)),
                              //         if(widget.order.service.inMinutes==0)
                              //           Text(
                              //               '${(widget.order.service.price)}',
                              //               style: TextStyle(color: Colors.blue,fontFamily: fonts,fontSize: 17)),
                              //         Text(
                              //             Languages.selectedLanguage == 0
                              //                 ? '
                              //                 : 'IQD',
                              //             style: TextStyle(color: Colors.blue,fontFamily: fonts,fontSize: 17)),
                              //       ],
                              //     )
                              //   ]),
                              //   TableRow(
                              //     children: [
                              //       Text('
                              //     :',style: textTheme),
                              //       Text('${widget.order.notes}',style: textTheme),
                              //     ]
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(
                height: 10,
              ),
              Container(
                  width: double.infinity,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                              Languages.selectedLanguage == 1
                                  ? 'Provider Notes '
                                  : "ملاحظات الموفر",
                              style: textTheme,
                              textDirection: ui.TextDirection.rtl),
                          Divider(),
                          Text('${widget.order.providerNotes}',
                              style: textTheme,
                              textDirection: ui.TextDirection.rtl),
                        ],
                      ),
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              //map
              Container(
                width: double.infinity,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          Languages.selectedLanguage == 1
                              ? 'Open Map '
                              : "فتح الخريطة",
                          style: textTheme,
                          textDirection: ui.TextDirection.rtl,
                        ),
                        Divider(),
                        Container(
                          width: double.infinity,
                          height: 200.0,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: GoogleMap(
                                mapToolbarEnabled: false,
                                onTap: (argument) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => userMapLoc(
                                      lat: double.parse(
                                          widget.order.lat.toString()),
                                      long: double.parse(
                                          widget.order.long.toString()),
                                      name: widget.order.user_name,
                                      phone: widget.order.user_phone,
                                    ),
                                  ));
                                },
                                myLocationEnabled: false,
                                buildingsEnabled: false,
                                myLocationButtonEnabled: false,
                                onMapCreated: (controller) {
                                  _completer.complete(controller);
                                },
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                      double.parse(widget.order.lat.toString()),
                                      double.parse(
                                          widget.order.long.toString())),
                                  zoom: 14.0,
                                ),
                                // markers: markers,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              //service
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                          Languages.selectedLanguage == 1
                              ? 'Service Name '
                              : 'اسم الخدمة ',
                          style: textTheme,
                          textDirection: ui.TextDirection.rtl),
                      Divider(),
                      Container(
                        margin: EdgeInsets.only(top: 3),
                        padding: EdgeInsets.all(7),
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(10)),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => DetailService(
                                    servceId: widget.order.service.id,
                                    isMyService: true,
                                  ),
                                ));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  widget.order.service.image,
                                  width: mediaQuery.width * 0.3,
                                  height: mediaQuery.height * 0.1,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '${allPro.numToString(widget.order.service.price)} '
                                      '${Languages.selectedLanguage == 0 ? 'دينار عراقي' : 'IQD'}',
                                      style: textTheme,
                                      textDirection: ui.TextDirection.rtl),
                                  Text(widget.order.service.name,
                                      style: textTheme,
                                      textDirection: ui.TextDirection.rtl),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: ExpansionPanelList(
                  expansionCallback: (panelIndex, isExpanded) {
                    setState(() {
                      isExpand = !isExpanded;
                    });
                  },
                  elevation: 2,
                  children: [
                    ExpansionPanel(
                      canTapOnHeader: true,
                      headerBuilder: (context, isExpanded) {
                        return Directionality(
                          textDirection: ui.TextDirection.rtl,
                          child: Container(
                            width: mediaQuery.width,
                            height: mediaQuery.height * 0.08,
                            child: Stack(
                              overflow: Overflow.visible,
                              children: [
                                Positioned(
                                  right: -53,
                                  top: !isExpand ? 10 : 0,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          Languages.selectedLanguage == 1
                                              ? 'Track Order'
                                              : 'ترتيب المسار',
                                          style: textTheme,
                                          textDirection: ui.TextDirection.rtl),
                                    ],
                                  ),
                                ),
                                if (isExpand)
                                  Positioned(
                                      top: 34,
                                      right: -53,
                                      left: 10,
                                      child: Divider()),
                              ],
                            ),
                          ),
                        );
                      },
                      isExpanded: isExpand,
                      body: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 8.0, right: 8, left: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Directionality(
                                  textDirection: ui.TextDirection.rtl,
                                  child: Column(children: [
                                    ...ordersTrack[widget.order.status]
                                  ]),
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text('messages: ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1),
                                    Text('${widget.order.notes}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              if (widget.order.status == 'finished' &&
                  widget.order.service_end_user_approval == null)
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.lightBlueAccent,
                  ),
                  child: FlatButton(
                      onPressed: () {
                        return buildShowCupertinoDialog(context,
                            Provider.of<Orders>(context, listen: false),
                            orderId: widget.order.id);
                      },
                      child: Text(
                        Languages.selectedLanguage == 1
                            ? 'Confirm receipt of order'
                            : 'تأكيد استلام الطلب',
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
    );
  }

  List<Widget> buildOrderStatus(String orderStatus) {
    print(orderStatus);
    List<Widget> buildList = [];
    // if (orderStatus == "order is rejected") {
    //   buildList.add(orderStatusWidgets[4]);
    //   return buildList;
    // }
    if (buildList.length <= 5) {
      if (orderStatus == "pending") {
        for (var i = 0; i < 1; i++) {
          buildList.add(orderStatusWidgets[i]);
        }
      }
      if (orderStatus == "technician_appointed") {
        for (var i = 0; i < 2; i++) {
          buildList.add(orderStatusWidgets[i]);
        }
      }
      if (orderStatus == "start") {
        for (var i = 0; i < 3; i++) {
          buildList.add(orderStatusWidgets[i]);
        }
      }
      if (orderStatus == "work_in_progress") {
        for (var i = 0; i < 4; i++) {
          buildList.add(orderStatusWidgets[i]);
        }
      }
      if (orderStatus == "finished") {
        for (var i = 0; i < 5; i++) {
          buildList.add(orderStatusWidgets[i]);
        }
      }
    }
    return buildList;
  }

  bool isExpand = true;

  final kBoxDecorationStyle2 = BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      gradient: LinearGradient(colors: [Colors.redAccent, Colors.pink]));

  TextEditingController notes = TextEditingController(text: '');

  bool isSendingImages = false;

  final kBoxDecorationStyle = BoxDecoration(
    borderRadius: new BorderRadius.circular(10),
    shape: BoxShape.rectangle,
    color: Colors.white,
    boxShadow: [
      BoxShadow(
          color: Colors.black26,
          offset: Offset(10, 5),
          blurRadius: 20,
          spreadRadius: -10)
    ],
  );

  List<File> files = [];

  Future pickFile() async {
    final List<PickedFile> images = await ImagePicker.platform.pickMultiImage();
    List<File> pickedFile = List<File>();
    setState(() {
      pickedFile = images.map((e) => File(e.path)).toList();
      for (int i = 0; i < pickedFile.length; i++) files.add(pickedFile[i]);
    });
  }

  bool isPressed = false;

  Completer<GoogleMapController> _completer = Completer();

  Future<void> animateTo(double lat, double lng) async {
    final c = await _completer.future;
    final p = CameraPosition(target: LatLng(lat, lng), zoom: 14.4746);
    c.animateCamera(CameraUpdate.newCameraPosition(p));
  }

  void show_before_after_Message({files}) {
    showCupertinoDialog(
        context: context,
        builder: (ctx) => StatefulBuilder(
              builder: (context, setState) => CupertinoAlertDialog(
                title: Text(
                  Languages.selectedLanguage == 0
                      ? "إرسال الصور قبل أو بعد أو بين"
                      : 'Send photos before, after, or between',
                  style: Theme.of(ctx).textTheme.bodyText2,
                ),
                actions: <Widget>[
                  //Cancel Order'
                  CupertinoButton(
                    child: Text(
                      Languages.selectedLanguage == 0 ? 'Back' : 'Back',
                      style: TextStyle(
                          fontFamily: 'Tajawal-Regular', color: Colors.red),
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  ),
                  //'start Now!
                  CupertinoButton(
                    child: isStarting
                        ? CupertinoActivityIndicator()
                        : Text(
                            Languages.selectedLanguage == 0
                                ? 'before'
                                : 'before',
                            style: TextStyle(
                                fontFamily: 'Tajawal-Regular',
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                    onPressed: () {
                      setState(() {
                        isStarting = true;
                      });
                      print('start now...');
                      setState(() {
                        isStarting = true;
                      });
                      Provider.of<Orders>(context, listen: false)
                          .sendImages(
                              files: files,
                              ordersId: widget.order.id,
                              notes: notes.text,
                              status: 'before')
                          .then((value) {
                        setState(() {
                          isStarting = false;
                          if (value == true) {
                            ToastGF.showMessage(context, 'send');
                            files = [];
                            notes.clear();
                          } else {
                            setState(() {
                              isStarting = false;
                              ToastGF.showError(context, 'not send');
                            });
                          }
                        });
                      });
                    },
                  ),
                  // 'end now',
                  CupertinoButton(
                      child: isEnding
                          ? CupertinoActivityIndicator()
                          : Text(
                              Languages.selectedLanguage == 0
                                  ? 'after'
                                  : 'after',
                              style: TextStyle(
                                  fontFamily: 'Tajawal-Regular',
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                      onPressed: () {
                        setState(() {
                          isEnding = true;
                        });
                        print('start now...');
                        Provider.of<Orders>(context, listen: false)
                            .sendImages(
                                files: files,
                                ordersId: widget.order.id,
                                notes: notes.text,
                                status: 'after')
                            .then((value) {
                          setState(() {
                            isEnding = false;
                            if (value == true) {
                              ToastGF.showMessage(context, 'sent sucessfully');
                              files = [];
                              notes.clear();
                            } else {
                              setState(() {
                                isEnding = false;
                                ToastGF.showError(context, '');
                              });
                            }
                          });
                        });
                      }),
                  //inBetween
                  CupertinoButton(
                      child: inBetween
                          ? CupertinoActivityIndicator()
                          : Text(
                              Languages.selectedLanguage == 0
                                  ? 'inBetween'
                                  : 'inBetween',
                              style: TextStyle(
                                  fontFamily: 'Tajawal-Regular',
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                      onPressed: () {
                        setState(() {
                          inBetween = true;
                        });
                        print('start now...');
                        Provider.of<Orders>(context, listen: false)
                            .sendImages(
                                files: files,
                                ordersId: widget.order.id,
                                notes: notes.text,
                                status: 'inBetween')
                            .then((value) {
                          setState(() {
                            inBetween = false;
                            if (value == true) {
                              ToastGF.showMessage(context, '');
                              files = [];
                              notes.clear();
                            } else {
                              setState(() {
                                inBetween = false;
                                ToastGF.showError(context, '');
                              });
                            }
                          });
                        });
                      })
                ],
              ),
            ));
  }
}
