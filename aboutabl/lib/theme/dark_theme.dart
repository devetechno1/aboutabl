import 'package:flutter/material.dart';

ThemeData get dark {
  const Color primary = Color(0xFFff6005);
  const Color secondary = Color(0xFF0052A3);
  return ThemeData(
    fontFamily: 'TitilliumWeb',
    primaryColor: primary,
    brightness: Brightness.dark,
    highlightColor: const Color(0xFF252525),
    hintColor: const Color(0xFFc7c7c7),
    cardColor: const Color(0xFF242424),
    scaffoldBackgroundColor: const Color(0xFF000000),
    splashColor: Colors.transparent,
    colorScheme: const ColorScheme.dark(
      primary: primary,
      secondary: secondary,
      tertiary: Color(0xFF865C0A),
      tertiaryContainer: Color(0xFF6C7A8E),
      surface: Color(0xFF2D2D2D),
      onPrimary: Color(0xFFE98B54),
      onTertiaryContainer: Color(0xFF0F5835),
      primaryContainer: Color(0xFF208458),
      onSecondaryContainer: Color(0x912A2A2A),
      outline: Color(0xff2C66B4),
      onTertiary: Color(0xFF545252),
      secondaryContainer: Color(0xFFF2F2F2),
    ),
    textTheme: const TextTheme(bodyLarge: TextStyle(color: Color(0xFFE9EEF4))),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
    }),
  );
}
