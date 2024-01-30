import 'package:flutter/material.dart';

class MyTheme {
  static const TextTheme textTheme = TextTheme(
    bodyLarge: TextStyle(
      fontWeight: FontWeight.w300,
      height: 1.8,
    ),
    bodyMedium: TextStyle(
      fontWeight: FontWeight.w400,
      height: 1.8,
    ),
    bodySmall: TextStyle(
      fontWeight: FontWeight.w200,
      height: 1.8,
    ),
    labelLarge: TextStyle(
      fontFamily: 'NotoSerifMyanmar',
      fontWeight: FontWeight.w400,
    ),
    labelMedium: TextStyle(
      // fontFamily: 'NotoSerifMyanmar',
      fontWeight: FontWeight.w300,
    ),
    labelSmall: TextStyle(
      // fontFamily: 'NotoSerifMyanmar',
      fontWeight: FontWeight.w200,
    ),
    headlineLarge: TextStyle(
      fontFamily: 'NotoSerifMyanmar',
      fontWeight: FontWeight.w800,
      fontSize: 24,
      height: 1.8,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'NotoSerifMyanmar',
      fontWeight: FontWeight.w700,
      fontSize: 22,
      height: 1.8,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'NotoSerifMyanmar',
      fontWeight: FontWeight.w600,
      fontSize: 18,
      height: 1.8,
    ),
  );
}
