import 'package:flutter/material.dart';

import '../../app/constants/theme_constant.dart';

class AppTheme {
  AppTheme._();

  static getApplicationTheme({required bool isDarkMode}) {
    return ThemeData(
      primaryColor: ThemeConstant.primaryColor,
      secondaryHeaderColor: ThemeConstant.background,
      scaffoldBackgroundColor: ThemeConstant.background,
      fontFamily: 'Montserrat Regular',

      // CircularProgressIndicator Theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: ThemeConstant.primaryColor, // Sets the color for CircularProgressIndicator
      ),

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        color: ThemeConstant.primaryColor,
        elevation: 4,
        shadowColor: Colors.black,
        titleTextStyle: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500, fontFamily: 'Montserrat-Regular'),
          backgroundColor: ThemeConstant.primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
      ),

      // Input Decoration Theme for TextFields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Colors.grey[400]!)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: const BorderSide(color: ThemeConstant.primaryColor)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: ThemeConstant.primaryColor, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: const BorderSide(color: Colors.red)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: const BorderSide(color: Colors.red, width: 2.0)),
        hintStyle: TextStyle(fontSize: 16, color: Colors.grey[600]),
        labelStyle: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w400),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: ThemeConstant.background, textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        checkColor: WidgetStateProperty.all(ThemeConstant.primaryColor),
        // Color of the checkmark
        fillColor: WidgetStateProperty.all(Colors.white),
        // Color of the checkbox
        side: WidgetStateBorderSide.resolveWith((states) {
          return BorderSide(
            color: ThemeConstant.primaryColor, // Border color of the checkbox
            width: 2,
          );
        }),
      ),
    );
  }
}
