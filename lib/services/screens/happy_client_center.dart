import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_sahla/ecomerce/helpers/font.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/services/providers/HappyCenter.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

class HappyClientCenter extends StatefulWidget {
  HappyClientCenter({Key key}) : super(key: key);

  @override
  State<HappyClientCenter> createState() => _HappyClientCenterState();
}

class _HappyClientCenterState extends State<HappyClientCenter> {
  var _key = GlobalKey<FormState>();

  String name;
  String phone;
  String reason;
  String email;
  String message;



  @override
  Widget build(BuildContext context) {
    void showInSnackBar(String value) {
      FocusScope.of(context).requestFocus(new FocusNode());
      ScaffoldMessenger.of(context)?.removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        new SnackBar(
          behavior: SnackBarBehavior.floating,
          content: new Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontFamily: fonts
            ),
          ),
          backgroundColor: Theme
              .of(context)
              .accentColor,
          duration: Duration(seconds: 3),
        ),);
    }
    final mediaQ = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          Languages.selectedLanguage == 0
              ? "مركز إسعاد المتعاملين"
              : 'Customer Happiness Center',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Form(
        key: _key,
        child: SingleChildScrollView(
          child: Column(
            children: [
            Image.asset(
            'assets/images/happy1.jpg',
            width: mediaQ.width * 1,
            fit: BoxFit.cover,
            height: mediaQ.height * 0.22,
          ),
          textFiled(1, 'الاسم(مطلوب)', 'الاسم', context),
          textFiled(2, 'رقم الجوال(مطلوب)', 'رقم الجوال', context),
          textFiled(3, 'دجاء اختيار السبب(اختيادي)', 'سبب التواصل', context),
          textFiled(4, 'البرية الالكتروني(اختياري)', 'البرية الالكتروني', context),
          SizedBox(
            height: 8,
          ),
          textFiled(
              5, 'تعليقك(مطلوب)', 'الرسالة', context),
          SizedBox(height: 10,),
          Row(
              children: [
          Expanded(
          child: RaisedButton(
          onPressed: ()
          {
          if (_key.currentState.validate()) {
          _key.currentState.save();
          Provider.of<HappyCenter>(context,listen: false).sendHappyCenter(
          name: name,
          phone: phone,
          email: email,
          message: message,
          reason: reason).then((value){
          if(value) {
          showInSnackBar(
          Languages.selectedLanguage == 0
          ?"أرسل الطلب بنجاح"
              : "the request send successfully",);
          _key.currentState.reset();
          }else
          showInSnackBar(
          Languages.selectedLanguage == 0
          ? "الطلب لا يرسل"
              : "the request not send",);
          });
          }
          },
          color: Theme
              .of(context)
              .accentColor,
          child: Text(
              Languages.selectedLanguage == 0 ? 'أرسل' : 'send',
              style: Theme.of(context).textTheme.headline2,
        ),
      ),
    ),
    ],
    ),
    ],
    ),
    ),
    )
    ,
    );
  }

  Widget textFiled(int index, String hint, String label, context) {
    final lang = Provider.of<Languages>(context);
    return Padding(
        padding: const EdgeInsets.only(right: 18.0, left: 18),
        child: Column(
          children: [
            Directionality(
              textDirection: ui.TextDirection.rtl,
              child: TextFormField(
                onSaved: (newValue) {
                  if (index == 1) name = newValue;
                  if (index == 2) phone = newValue;
                  if (index == 3) reason = newValue;
                  if (index == 4) email = newValue;
                  if (index == 5) message = newValue;
                },
                style: Theme
                    .of(context)
                    .textTheme
                    .headline4,
                validator: (value) {
                  if (index == 4)
                    return null;
                  else if (value.isEmpty)
                    return 'please fill fileds';
                  else
                    return null;
                },
                maxLines: index == 5 ? 3 : 1,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(
                        right: index == 1
                            ? 100
                            : index == 2
                            ? 70
                            : index == 3
                            ? 60
                            : index == 4
                            ? 45
                            : 100,
                        top: 0),
                    border: InputBorder.none,
                    hintText: label,
                    hintStyle: TextStyle(
                        color: Theme
                            .of(context)
                            .textTheme
                            .headline4
                            .color,
                        fontSize: 14,
                        fontFamily: fonts),
                    icon: Container(
                        child: Text(
                          hint,
                          style: TextStyle(
                              color: Theme
                                  .of(context)
                                  .textTheme
                                  .headline4
                                  .color,
                              fontSize: 14,
                              fontFamily: fonts),
                        ))),
                textAlign: TextAlign.right,
              ),
            ),
            Divider(
              color: Theme
                  .of(context)
                  .textTheme
                  .headline4
                  .color,
              thickness: 0.4,
              height: 0,
            )
          ],
        ));
  }}