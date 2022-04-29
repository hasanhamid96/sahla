
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/services/providers/Orders.dart';
import 'package:provider/provider.dart';

import 'Rating.dart';
bool isStarting = false;
bool isEnding = false;
bool inBetween = false;
void showFinishStartMessage({isStart: false, context,orderId,server_id}) {
  showCupertinoDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (context, setState) => CupertinoAlertDialog(
          title: Text(
            isStart
                ? Languages.selectedLanguage == 0
                ? "هل بدأت الخدمة؟"
                : 'did start service?'
                : Languages.selectedLanguage == 0
                ? "هل انتهت الخدمة؟"
                : 'did end service?',
            style: Theme.of(ctx).textTheme.bodyText2,
          ),
          actions: <Widget>[
      //Cancel '
      CupertinoButton(
      child: Text(Languages.selectedLanguage == 0 ? 'رجوع' :  'Back',
      style: TextStyle(
      fontFamily: 'ithra', color: Colors.red),
    ),
    onPressed: () {
      Navigator.of(ctx).pop();
    },
  ),
  // 'start Now!
  CupertinoButton(
  child: isStarting
  ? CupertinoActivityIndicator()
      : Text(
  Languages.selectedLanguage == 0
  ? 'قبول'
      : 'Accept',
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
  Provider.of<Orders>(context, listen: false)
      .userApproval(
  approval:  1 ,
  type: isStart? 'start':'end',
  time: DateTime.now().toIso8601String(),
  orderId: orderId)
      .then((value) {
  setState(() {
  isStarting = false;
  Navigator.pop(context);
  if(!isStart) {
  Rating.showRatingDialog(context, server_id);
  }
  });
  }).catchError((e) {
  setState(() {
  isStarting = false;
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
  ? 'رفض'
      : 'Decline',
  style: TextStyle(
  fontFamily: 'ithra',
  color: Colors.green,
  fontWeight: FontWeight.bold),
  ),
  onPressed: () {
  setState(() {
  isEnding = true;
  });
  print('start now...');
  Provider.of<Orders>(context, listen: false)
      .userApproval(
  approval:  0,
  type:  isStart?'start':'end',
  time: DateTime.now().toIso8601String(),
  orderId: orderId)
      .then((value) {
  setState(() {
  isEnding = false;
  Navigator.pop(context);
  // Rating.showRatingDialog(context,server_id);
  });
  }).catchError((e) {
  setState(() {
  isEnding = false;
  });
  });
  })
  ],
  ),
  ));}