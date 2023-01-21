import 'package:flutter/material.dart';
import 'package:year_planner/theme/custom_colors.dart';
import 'package:year_planner/theme/text_style.dart';

ThemeData getTheme(Color mainColor) => ThemeData(
    colorSchemeSeed: mainColor,
    scaffoldBackgroundColor: greyBG,
    dividerColor: grey00,
    textTheme: getTextTheme(mainColor),
    primaryTextTheme: customPrimaryTextTheme,
    appBarTheme: const AppBarTheme(elevation: 0),
    inputDecorationTheme: const InputDecorationTheme(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: grey02, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        )));

/// TODO: create dark theme