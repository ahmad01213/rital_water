import 'dart:io';

import 'package:cuberto_bottom_bar/cuberto_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ritakwaterapp/UI/Screens/cart_screen.dart';
import 'package:ritakwaterapp/UI/Screens/contact_us_screen.dart';
import 'package:ritakwaterapp/UI/Screens/favorites_screen.dart';
import 'package:ritakwaterapp/UI/Screens/home_screen.dart';
import 'package:ritakwaterapp/UI/Screens/my_account_screen.dart';
import 'package:ritakwaterapp/UI/Screens/my_orders_screen.dart';
import 'package:ritakwaterapp/UI/Screens/offers_screen.dart';
import 'package:ritakwaterapp/UI/Screens/points_screen.dart';
import 'package:ritakwaterapp/UI/Screens/splash_screen.dart';
import 'package:ritakwaterapp/shared_data.dart';

import 'UI/Screens/about_us_screen.dart';

void main() {
  runApp(MaterialApp(
    title: 'ريتال',
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate
    ],
    supportedLocales: [
      Locale('ar', 'AE'), // OR Locale('ar', 'AE') OR Other RTL locales
    ],
    locale: Locale('ar', 'AE'),
    theme: ThemeData(
//        fontFamily: 'default',
        appBarTheme: AppBarTheme(
          elevation: 0, // This removes the shadow from all App Bars.
        ),
        primaryColor: mainColor),
    home: SplashScreen(),
  ));
  HttpOverrides.global = new MyHttpOverrides();
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
