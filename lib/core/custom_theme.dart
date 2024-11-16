import 'package:flutter/material.dart';
import 'package:taxi_park/core/custom_colors.dart';

ThemeData customTheme = ThemeData(
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
  ),
  textTheme: customTextTheme,
  colorScheme: customColorScheme,
);

ColorScheme customColorScheme = ColorScheme.fromSeed(
  seedColor: CustomColors.primaryColor,
);

TextTheme customTextTheme = const TextTheme(
    // displaySmall: TextStyle(fontSize: 20),
    );
