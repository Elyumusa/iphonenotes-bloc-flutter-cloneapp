import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class AppTheme {
  const AppTheme._();
  static Color lightBackgroundColor = Colors.white;
  static Color lightPrimaryColor = Colors.white;
  static Color darkBackgroundColor = Colors.black;
  static final lightTheme = ThemeData(
    appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.yellowAccent[700],
          size: 32,
        ),
        toolbarTextStyle: TextStyle(color: Colors.yellowAccent[700]),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(fontSize: 20, color: Colors.black)),
    brightness: Brightness.light,
    primaryColor: Colors.white,
    iconTheme: IconThemeData(
      color: Colors.yellowAccent[700],
      size: 32,
    ),
    textTheme: TextTheme(
        headlineLarge: TextStyle(color: Colors.black),
        headlineMedium: TextStyle(color: Colors.black),
        headlineSmall: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.black),
        bodyLarge: TextStyle(color: Colors.black)),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.yellowAccent[700],
          size: 32,
        ),
        titleTextStyle: TextStyle(fontSize: 20, color: Colors.white)),
    brightness: Brightness.dark,
    textTheme: TextTheme(
        headlineLarge: TextStyle(color: Colors.white),
        headlineMedium: TextStyle(color: Colors.white),
        headlineSmall: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
        bodyLarge: TextStyle(color: Colors.white)),
    bottomNavigationBarTheme:
        const BottomNavigationBarThemeData(selectedItemColor: Colors.white),
    primaryColor: Colors.black,
    colorScheme: ColorScheme.dark(
      background: Colors.black,
    ),
    iconTheme: IconThemeData(
      color: Colors.yellowAccent[700],
      size: 32,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
  static Brightness get currentSystemBrightness =>
      SchedulerBinding.instance.window.platformBrightness;
  static setStatusBarAndNavigationBarColors(ThemeMode themeMode) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
          themeMode == ThemeMode.light ? Brightness.dark : Brightness.light,
      systemNavigationBarIconBrightness:
          themeMode == ThemeMode.light ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: themeMode == ThemeMode.light
          ? lightBackgroundColor
          : darkBackgroundColor,
      systemNavigationBarDividerColor: Colors.transparent,
    ));
  }
}
