import 'package:flutter/material.dart';

// Star Wars color scheme: deep space + crawl yellow
const Color primaryYellow = Color(0xFFFFD700); // Strong yellow (crawl text)
const Color backgroundDark = Color(0xFF000000); // Deep black space
const Color surfaceDark = Color(0xFF121212); // Slightly lighter surface
const Color textLight = Color(0xFFE0E0E0); // Light gray text
const Color errorRed = Color(0xFFB00020); // Error red

final ThemeData starWarsTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: backgroundDark,
  colorScheme: const ColorScheme.dark(
    primary: primaryYellow,
    secondary: primaryYellow,
    background: backgroundDark,
    surface: surfaceDark,
    error: errorRed,
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onBackground: textLight,
    onSurface: textLight,
    onError: Colors.white,
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: backgroundDark,
    foregroundColor: primaryYellow,
    elevation: 6,
    titleTextStyle: TextStyle(
      color: primaryYellow,
      fontSize: 22,
      fontWeight: FontWeight.bold,
      // fontFamily: 'StarJedi', // Optional
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryYellow,
      foregroundColor: Colors.black,
      textStyle: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: primaryYellow,
      side: const BorderSide(color: primaryYellow),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  ),

  cardTheme: CardTheme(
    color: surfaceDark,
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    labelStyle: const TextStyle(color: textLight),
    hintStyle: TextStyle(color: textLight.withOpacity(0.6)),
    filled: true,
    fillColor: surfaceDark,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: textLight.withOpacity(0.3)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: textLight.withOpacity(0.3)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: primaryYellow, width: 2),
    ),
    prefixIconColor: textLight.withOpacity(0.7),
  ),

  iconTheme: const IconThemeData(color: primaryYellow),

  snackBarTheme: SnackBarThemeData(
    backgroundColor: surfaceDark,
    contentTextStyle: const TextStyle(color: textLight),
    actionTextColor: primaryYellow,
  ),

  dialogTheme: DialogTheme(
    backgroundColor: surfaceDark,
    titleTextStyle: const TextStyle(color: primaryYellow, fontSize: 18),
    contentTextStyle: const TextStyle(color: textLight),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),

  dividerTheme: DividerThemeData(
    color: textLight.withOpacity(0.3),
    thickness: 0.5,
  ),

  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: primaryYellow,
    circularTrackColor: surfaceDark,
  ),

  listTileTheme: ListTileThemeData(
    tileColor: surfaceDark,
    textColor: textLight,
    iconColor: primaryYellow,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    dense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  ),

  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: backgroundDark,
    indicatorColor: primaryYellow.withOpacity(0.15),
    labelTextStyle: MaterialStateProperty.all(
      const TextStyle(color: textLight, fontSize: 12),
    ),
    iconTheme: MaterialStateProperty.resolveWith((states) {
      return IconThemeData(
        color: states.contains(MaterialState.selected)
            ? primaryYellow
            : textLight.withOpacity(0.6),
      );
    }),
  ),
);
