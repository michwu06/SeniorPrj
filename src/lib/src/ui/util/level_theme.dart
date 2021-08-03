import 'package:flutter/material.dart';

class LevelTheme {
  // Use white to fill buttons that appear ontop of a
  // purple decoration.
  static const Color levelWhite = Colors.white;

  // Light purple is used for some decorations (See Alignment Instructions)
  static const Color levelLightPurple = Color(0xFF353358);

  // Use dark purple for button text of white buttons
  // Add transparency to dark purple decorations if needed
  static const Color levelDarkPurple = Color(0xFF070435);

  static ThemeData levelThemeData() {
    return ThemeData(
      primaryColor: Colors.white,
      accentColor: LevelColor,
      fontFamily: 'Roboto',
      textTheme: TextTheme(
        //beforeInput: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey, fontFamily: 'Roboto'),
        //screenTitle: TextStyle(color: LevelColor, fontSize: 24, height: 2, fontFamily: 'Roboto'),
        headline1: TextStyle(
          // 'Name Your Event' in set_lineup
          color: LevelColor,
          fontSize: 22,
          height: 2,
          fontFamily: 'Roboto',
        ),
        headline2: TextStyle(
            color: LevelColor,
            fontSize: 14,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold),
      ),
    );
  }

  static Text levelHeadlineOneText(String text) {
    return Text(
      text,
      style: levelThemeData().textTheme.headline1,
    );
  }

  static Text levelSmallHeadlineText(String text) {
    return Text(
      text,
      style: levelThemeData().textTheme.headline2,
    );
  }
}

const MaterialColor LevelColor = const MaterialColor(
  0xFF070435,
  const <int, Color>{
    50: const Color(0xFF070435),
    100: const Color(0xFF070435),
    200: const Color(0xFF070435),
    300: const Color(0xFF070435),
    400: const Color(0xFF070435),
    500: const Color(0xFF070435),
    600: const Color(0xFF070435),
    700: const Color(0xFF070435),
    800: const Color(0xFF070435),
    900: const Color(0xFF070435),
  },
);
