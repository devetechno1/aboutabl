import 'package:flutter/material.dart';

ThemeData light({
  Color? primaryColor,
  Color? secondaryColor,
}) {
  primaryColor ??= const Color(0xFFffcc66);
  secondaryColor ??= const Color(0xFF003366);

  return ThemeData(
    fontFamily: 'TitilliumWeb',
    primaryColor: primaryColor,
    brightness: Brightness.light,
    highlightColor: Colors.white,
    hintColor: const Color(0xFF9E9E9E),
    splashColor: Colors.transparent,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: const Color(0xFFF9D4A8),
      tertiaryContainer: const Color(0xFFE0C99B),
      onTertiaryContainer: const Color(0xFF33AF74),
      onPrimary: const Color(0xFF7FBBFF),
      surface: const Color(0xFFF4F8FF),
      onSecondary: const Color(0xFFF88030),
      error: const Color(0xFFFF5555),
      onSecondaryContainer: const Color(0xFFF3F9FF),
      outline: const Color(0xff2C66B4),
      onTertiary: const Color(0xFFE9F3FF),
      primaryContainer: const Color(0xFF9AECC6),
      secondaryContainer: const Color(0xFFF2F2F2),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
    }),
  );
}
