import 'package:flutter/material.dart';

enum AppTheme { White, Dark }

var fonts = 'ithra';

/// Returns enum value name without enum class name.
String enumName(AppTheme anyEnum) {
  return anyEnum.toString().split('.')[1];
}

//json key:value
final appThemeData = {
  AppTheme.White: ThemeData(
      fontFamily: 'ithra',
      canvasColor: Color.fromRGBO(243, 248, 253, 1),
      primaryColor: Color.fromRGBO(27, 141, 214, 1),
      accentColor: Color.fromRGBO(27, 141, 214, 1),
      bottomAppBarColor: Color(0xff313e4b),
      appBarTheme: AppBarTheme(
        color: Color.fromRGBO(27, 141, 214, 1),
        textTheme: TextTheme(
          bodyText1: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontFamily: 'ithra',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      hoverColor: Colors.white,
      textTheme: ThemeData.light().textTheme.copyWith(
            bodyText1: TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontFamily: 'ithra',
            ),
            headline1: TextStyle(
              fontSize: 15,
              color: Colors.black87,
              fontWeight: FontWeight.normal,
              fontFamily: 'ithra',
            ),
            headline2: TextStyle(
              fontSize: 17,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'ithra',
            ),
            headline3: TextStyle(
              fontSize: 17,
              color: Colors.black45,
              fontWeight: FontWeight.normal,
              fontFamily: 'ithra',
            ),
            headline4: TextStyle(
              fontSize: 15,
              color: Colors.black54,
              fontFamily: 'ithra',
              fontWeight: FontWeight.normal,
            ),
            headline5: TextStyle(
              fontSize: 14,
              color: Colors.black54,
              fontFamily: 'ithra',
              fontWeight: FontWeight.normal,
            ),
            headline6: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontFamily: 'ithra',
              fontWeight: FontWeight.normal,
            ),
            subtitle1: TextStyle(
              fontSize: 13,
              color: Colors.black38,
              fontFamily: 'ithra',
              fontWeight: FontWeight.normal,
            ),
          )),
  AppTheme.Dark: ThemeData(
      fontFamily: 'ithra',
      dividerColor: Colors.black45,
      brightness: Brightness.dark,
      cardColor: Colors.white,
      // primaryColor: Color(0xFF1E1E2C),
      scaffoldBackgroundColor: Color(0xff222324),
      backgroundColor: Color(0xff222324),
      primaryColor: Color.fromRGBO(27, 141, 214, 1),
      accentColor: Colors.grey[400],
      bottomAppBarColor: Colors.white,
      canvasColor: Color(0xff222324),
      appBarTheme: AppBarTheme(
        color: Color(0xFF656565),
        textTheme: TextTheme(
          bodyText1: TextStyle(
            fontSize: 20,
            fontFamily: 'ithra',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      hoverColor: Color(0xFF656565),
      textTheme: ThemeData.dark().textTheme.copyWith(
            bodyText1: TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontFamily: 'ithra',
            ),
            headline1: TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontFamily: 'ithra',
            ),
            headline2: TextStyle(
              fontSize: 17,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'ithra',
            ),
            headline3: TextStyle(
              fontSize: 17,
              color: Colors.white70,
              fontFamily: 'ithra',
              fontWeight: FontWeight.normal,
            ),
            headline4: TextStyle(
              fontSize: 15,
              color: Colors.white70,
              fontFamily: 'ithra',
              fontWeight: FontWeight.normal,
            ),
            headline5: TextStyle(
              fontSize: 14,
              color: Colors.black54,
              fontFamily: 'ithra',
              fontWeight: FontWeight.normal,
            ),
            headline6: TextStyle(
              fontSize: 20,
              color: Colors.black54,
              fontFamily: 'ithra',
              fontWeight: FontWeight.normal,
            ),
            subtitle1: TextStyle(
              fontSize: 13,
              color: Colors.white60,
              fontFamily: 'ithra',
              fontWeight: FontWeight.normal,
            ),
          ))
};
