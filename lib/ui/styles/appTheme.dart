import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsly/ui/styles/colors.dart';

class AppTheme {
  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: pageBackgroundColor,
      textTheme: GoogleFonts.interTextTheme(base.textTheme),
      colorScheme: base.colorScheme.copyWith(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: backgroundColor,
        error: errorColor,
        tertiary: tertiaryColor,
      ),
      extensions: const <ThemeExtension<dynamic>>[lightCustomColors],
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: secondaryColor,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
      ),
    );
  }

  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: darkPageBackgroundColor,
      textTheme: GoogleFonts.interTextTheme(base.textTheme),
      colorScheme: base.colorScheme.copyWith(
        primary: primaryColor,
        secondary: Colors.white,
        surface: darkBackgroundColor,
        error: errorColor,
        tertiary: darkTertiaryColor,
      ),
      extensions: const <ThemeExtension<dynamic>>[darkCustomColors],
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackgroundColor,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
      ),
    );
  }
}
