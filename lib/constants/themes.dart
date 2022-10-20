import 'package:flutter/material.dart';

class Themes {
  ThemeData defaultTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.red,
    primaryColor: const Color(0xff900000),
    bottomAppBarColor: Colors.grey[850],
    backgroundColor: Colors.grey[800],
    accentColor: const Color(0xff900000),
    highlightColor: const Color(0xfff9b900),
    secondaryHeaderColor: const Color(0xff900000),
    iconTheme: IconThemeData(
      color: const Color(0xffffffff),
      size: 15,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
            foregroundColor:
                MaterialStateProperty.all<Color>(Color(0xFFFFFFFF)))),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white))),
    // primaryTextTheme: TextTheme(bodyText2: TextStyle(color: Colors.white)),
    scrollbarTheme: ScrollbarThemeData(
      thickness: MaterialStateProperty.all<double>(8),
      radius: Radius.circular(8),
      thumbColor: MaterialStateProperty.all<Color>(Color(0xFFB71C1C)),
      trackColor: MaterialStateProperty.all<Color>(Colors.grey),
      // trackBorderColor: MaterialStateProperty.all<Color>(ThemeColor().mainColor),
      minThumbLength: 10,
      crossAxisMargin: 1,
      mainAxisMargin: 2,
    ),
    switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.all<Color>(Color(0xFFB71C1C)),
        trackColor: MaterialStateProperty.all<Color>(Colors.grey)),
  );

  ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.grey,
    primaryColor: const Color(0xff000000),
    accentColor: Colors.grey[900],
    highlightColor: Colors.grey[300],
    bottomAppBarColor: const Color(0xff000000),
    secondaryHeaderColor: const Color(0xff000000),
    primaryTextTheme: TextTheme(),
    iconTheme: IconThemeData(
      color: const Color(0xffffffff),
      size: 15,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.black))),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white))),
    scrollbarTheme: ScrollbarThemeData(
      thickness: MaterialStateProperty.all<double>(8),
      radius: Radius.circular(8),
      trackColor: MaterialStateProperty.all<Color>(Colors.grey),
      thumbColor: MaterialStateProperty.all<Color>(Colors.black),
      // trackBorderColor: MaterialStateProperty.all<Color>(ThemeColor().mainColor),
      minThumbLength: 10,
      crossAxisMargin: 3,
      mainAxisMargin: 2,
    ),
    switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.all<Color>(Colors.black),
        trackColor: MaterialStateProperty.all<Color>(Colors.grey)),
  );
}
