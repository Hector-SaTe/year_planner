import 'package:flutter/material.dart';
import 'package:year_planner/theme/custom_colors.dart';
import 'package:year_planner/theme/text_style.dart';

final lightTheme = ThemeData(
  primarySwatch: Colors.deepPurple,
  scaffoldBackgroundColor: greyBG,
  dividerColor: grey00,
  appBarTheme: const AppBarTheme(elevation: 0),
  textTheme: customTextTheme,
  primaryTextTheme: customPrimaryTextTheme,
);
