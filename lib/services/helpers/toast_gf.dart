
import 'package:fl_toast/fl_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/helpers/app_themes.dart';

class ToastGF  {
  static void showError(context,title,)async{
    return
      await showStyledToast(
          alignment: Alignment.topCenter,
          margin: EdgeInsets.only(top: 50),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          backgroundColor: Colors.redAccent,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 10,height: 30,),
              Container(
                  width: 200,
                  child: Text('$title',style: TextStyle(color: Colors.white,),)),
              SizedBox(width: 5,),
              InkWell(
                  onTap: () {
                    ToastManager.dismissAll();
                  },
                  child: Icon(CupertinoIcons.clear_circled_solid,color: Colors.white,))
            ],
          ),
          context: context,
          animationDuration: Duration(milliseconds: 100),
          animationBuilder: (context, animation, child) {
            return SlideTransition(
              position: Tween(
                  begin: Offset(0,0.4),
                  end: Offset(0,0)
              ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.fastLinearToSlowEaseIn,)),
              child: FadeTransition(
                  opacity: animation,
                  child: child),
            );
          }
      );
  }
  static void showMessage(context,title,)async{
    return
      await showStyledToast(
          alignment: Alignment.topCenter,
          margin: EdgeInsets.only(top: 50),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          backgroundColor: Colors.greenAccent,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 10,height: 30,),
              Container(
                  width: 200,
                  child: Text('$title',style: TextStyle(color: Colors.white,),)),
              SizedBox(width: 5,),
              InkWell(
                  onTap: () {
                    ToastManager.dismissAll();
                  },
                  child: Icon(CupertinoIcons.clear_circled_solid,color: Colors.white,))
            ],
          ),
          context: context,
          animationDuration: Duration(milliseconds: 100),
          animationBuilder: (context, animation, child) {
            return SlideTransition(
              position: Tween(
                  begin: Offset(0,0.4),
                  end: Offset(0,0)
              ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.fastLinearToSlowEaseIn,)),
              child: FadeTransition(
                  opacity: animation,
                  child: child),
            );
          }
      );
  }
  static void showInSnackBar(String value,context) {
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
        backgroundColor: Theme.of(context).accentColor,
        duration: Duration(seconds: 3),
      ),);}}