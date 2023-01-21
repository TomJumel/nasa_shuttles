import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';

ThemeData buildTheme() {
  return ThemeData(
    primarySwatch: AppColors.primary,
    textTheme: const TextTheme(
      headline1: TextStyle(fontSize: 32, fontWeight: FontWeight.normal),
      headline2: TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
      headline3: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
      headline4: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
      headline5: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
      headline6: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
      bodyText1: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
      bodyText2: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
    ),
    scaffoldBackgroundColor: Colors.white,
  );
}

void initTheme() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
}
