import 'package:flutter/material.dart';
import 'package:prepvrse/common/constants/styles.dart';

class Themes {
  static ThemeData lightThemeData() {
    return ThemeData(
      fontFamily: "Outfit",
      brightness: Brightness.light,
      primaryColor: Styles.primaryColor,
      scaffoldBackgroundColor: Styles.backgroundColor,
      bottomSheetTheme:
          BottomSheetThemeData(backgroundColor: Styles.primaryColor),
    );
  }

// dark Theme
  static ThemeData darkThemeData() {
    return ThemeData(
      fontFamily: "Outfit",
      brightness: Brightness.dark,
      primaryColor: Styles.primaryColor,
      scaffoldBackgroundColor: Styles.backgroundColor,
      bottomSheetTheme:
          BottomSheetThemeData(backgroundColor: Styles.backgroundColor),
    );
  }
}
