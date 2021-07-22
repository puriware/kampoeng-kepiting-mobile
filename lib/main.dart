import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kampoeng_kepiting_mobile/constants.dart';
import 'package:kampoeng_kepiting_mobile/screens/main_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MaterialColor generateMaterialColor(Color color) {
    return MaterialColor(color.value, {
      50: tintColor(color, 0.9),
      100: tintColor(color, 0.8),
      200: tintColor(color, 0.6),
      300: tintColor(color, 0.4),
      400: tintColor(color, 0.2),
      500: color,
      600: shadeColor(color, 0.1),
      700: shadeColor(color, 0.2),
      800: shadeColor(color, 0.3),
      900: shadeColor(color, 0.4),
    });
  }

  int tintValue(int value, double factor) =>
      max(0, min((value + ((255 - value) * factor)).round(), 255));

  Color tintColor(Color color, double factor) => Color.fromRGBO(
      tintValue(color.red, factor),
      tintValue(color.green, factor),
      tintValue(color.blue, factor),
      1);

  int shadeValue(int value, double factor) =>
      max(0, min(value - (value * factor).round(), 255));

  Color shadeColor(Color color, double factor) => Color.fromRGBO(
      shadeValue(color.red, factor),
      shadeValue(color.green, factor),
      shadeValue(color.blue, factor),
      1);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kampoeng Kepiting',
      theme: ThemeData(
        primarySwatch: generateMaterialColor(primaryColor),
        accentColor: Colors.amberAccent,
        fontFamily: 'PTSans',
        scaffoldBackgroundColor: primaryBackgrounColor,
        appBarTheme: AppBarTheme.of(context).copyWith(
          backgroundColor: primaryBackgrounColor,
          centerTitle: true,
          elevation: 0,
          foregroundColor: primaryColor,
          iconTheme: IconThemeData(color: primaryColor),
          textTheme: TextTheme(
            headline6: TextStyle(
              color: primaryColor,
              fontFamily: 'Anton',
              fontSize: 22,
              //fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // bottomNavigationBarTheme: BottomNavigationBarThemeData(
        //   //selectedIconTheme: IconThemeData(color: kPrimaryColor),
        //   //backgroundColor: Colors.purple,
        //   //selectedItemColor: kPrimaryColor,
        // ),
        textTheme: ThemeData.light()
            .textTheme
            .copyWith(
              bodyText1: TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              bodyText2: TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              headline6: TextStyle(
                fontFamily: 'PTSans',
                fontSize: 16,
                //fontWeight: FontWeight.bold,
              ),
            )
            .apply(
              displayColor: textColor,
            ),
      ),
      home: MainScreen(),
    );
  }
}
