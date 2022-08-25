import 'package:flutter/material.dart';

const ColorScheme kColorScheme = ColorScheme.dark(
  background: Color(0xFF303030),
  onBackground: Color(0xFF1E1E1E),
  surface: Color(0xFF08284A),
  onSurface: Colors.white,
  primary: Color(0xFF58B4FD),
  onPrimary: Color(0xFF0F3D65),
  secondary: Color(0xFFFB615B),
  onSecondary: Color(0xFF631310),
  tertiary: Color(0xFF61D761),
  onTertiary: Color(0xFF0E520E),
  error: Color(0xFFFEC861),
  onError: Color(0xFF6E4D0F),
  brightness: Brightness.dark,
  surfaceTint: Colors.white,
);
Color kDisabledButtonColor = Colors.grey.shade200;

Color kPrimaryBlue = const Color(0xFF58B4FD);
Color kSecondaryBlue = const Color(0xFF0F3D65);
Color kPrimaryRed = const Color(0xFFFB615B);
Color kSecondaryRed = const Color(0xFF631310);
Color kPrimaryGreen = const Color(0xFF61D761);
Color kSecondaryGreen = const Color(0xFF0E520E);
Color kPrimaryPurple = const Color(0xFF7964F1);
Color kSecondaryPurple = const Color(0xFF201369);
Color kPrimaryYellow = const Color(0xFFFEC861);
Color kSecondaryYellow = const Color(0xFF6E4D0F);
Color kTableHeadingColor = const Color(0xFF08284A);
Color kModalBackgroundColor = const Color(0xFF161616);

TextStyle kBaseTextStyle({double? fontSize, Color? color, FontWeight? fontWeight, TextDecoration? decoration, Paint? background}) {
  return TextStyle(
    fontSize: fontSize,
    color: color ?? Colors.white,
    fontWeight: fontWeight,
    decoration: decoration,
    background: background,
  );
}

Widget kCircularLoading = const SizedBox(
  height: 700.0,
  child: Center(
    child: CircularProgressIndicator(),
  ),
);