import 'package:flutter/material.dart';
import 'package:year_planner/theme/custom_colors.dart';

TextTheme getTextTheme(Color themeColor) => TextTheme(
      headlineLarge: TextStyle(
        color: themeColor,
        fontWeight: FontWeight.w700,
        fontSize: 50,
      ),
      headlineMedium: TextStyle(
        color: themeColor,
        fontWeight: FontWeight.w700,
        fontSize: 40,
      ),
      headlineSmall: TextStyle(
        color: base,
        fontWeight: FontWeight.w700,
        fontSize: 25,
      ),
      titleLarge: TextStyle(
        color: themeColor,
        fontWeight: FontWeight.w700,
        fontSize: 18,
      ),
      titleMedium: TextStyle(
        color: themeColor,
        fontWeight: FontWeight.w700,
        fontSize: 16,
      ),
      titleSmall: TextStyle(
        color: themeColor,
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
      bodyLarge: TextStyle(
        color: black_1,
        fontWeight: FontWeight.w700,
        fontSize: 14,
      ),
      bodyMedium: TextStyle(
        color: black_1,
        fontWeight: FontWeight.w400,
        fontSize: 14,
        letterSpacing: 0,
      ),
      bodySmall: TextStyle(
        color: black_1,
        fontWeight: FontWeight.w400,
        fontSize: 14,
        letterSpacing: 0,
      ),
      labelLarge: TextStyle(
        color: grey_3,
        fontWeight: FontWeight.w700,
        fontSize: 16,
        letterSpacing: 0,
      ),
      labelMedium: TextStyle(
        color: grey_3,
        fontWeight: FontWeight.w400,
        fontSize: 14,
        letterSpacing: 0,
      ),
      labelSmall: TextStyle(
        color: grey_3,
        fontWeight: FontWeight.w400,
        fontSize: 12,
        letterSpacing: 0,
      ),
    );

TextTheme customPrimaryTextTheme = const TextTheme(
  headlineLarge: TextStyle(
    color: white,
    fontWeight: FontWeight.w700,
    fontSize: 50,
  ),
  headlineMedium: TextStyle(
    color: white,
    fontWeight: FontWeight.w700,
    fontSize: 40,
  ),
  headlineSmall: TextStyle(
    color: white,
    fontWeight: FontWeight.w700,
    fontSize: 25,
  ),
  titleLarge: TextStyle(
    color: white,
    fontWeight: FontWeight.w700,
    fontSize: 18,
    letterSpacing: 0,
  ),
  titleMedium: TextStyle(
    color: white,
    fontWeight: FontWeight.w700,
    fontSize: 16,
    letterSpacing: 0,
  ),
  titleSmall: TextStyle(
    color: white,
    fontWeight: FontWeight.w500,
    fontSize: 16,
    letterSpacing: 0,
  ),
  bodyLarge: TextStyle(
    color: white,
    fontWeight: FontWeight.w700,
    fontSize: 14,
    letterSpacing: 0,
  ),
  bodyMedium: TextStyle(
    color: grey,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0,
  ),
  bodySmall: TextStyle(
    color: grey,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0,
  ),
  labelLarge: TextStyle(
    color: grey,
    fontWeight: FontWeight.w700,
    fontSize: 16,
    letterSpacing: 0,
  ),
  labelMedium: TextStyle(
    color: grey,
    fontWeight: FontWeight.w400,
    fontSize: 14,
  ),
  labelSmall: TextStyle(
    color: grey,
    fontWeight: FontWeight.w400,
    fontSize: 12,
  ),
);
