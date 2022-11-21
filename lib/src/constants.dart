import 'package:flutter/material.dart';

const String kIEXToken = 'YOUR_API_TOKEN'; // TODO: create your own API KEY

const ColorScheme kColorScheme = ColorScheme.dark(
  background: Color(0xFF303030),
  onBackground: Color(0xFF545454),
  surface: Color(0xFF08284A),
  onSurface: Colors.white,
  primary: Color(0xFF58B4FD),
  onPrimary: Color(0xFF0F3D65),
  secondary: Color(0xFFFB615B),
  onSecondary: Color(0xFF631310),
  tertiary: Color(0xFF61D761),
  onTertiary: Color(0xFF0E520E),
  error: Color(0xFFE74C3C),
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
Color kMutedTextColor = const Color(0xFFCCCCCC);
Color kSuccessColor = Colors.green;
Color kWarningColor = Colors.amber;

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

Widget notFound({double? height = 200, double? width = 390, required String label, AssetImage? image, Widget? icon}) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: height,
          width: width,
        ),
        CircleAvatar(
          radius: 35,
          backgroundColor: kColorScheme.primary.withOpacity(0.4),
          child: icon ??
              Image(
                image: image ?? const AssetImage('images/add-list.png'),
                height: 55.0,
                color: kColorScheme.primary,
              ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: kBaseTextStyle(
            fontSize: 15,
            color: kMutedTextColor,
          ),
        ),
      ],
    ),
  );
}

Widget loginLogoImage = const Hero(
  tag: 'logo_image',
  child: Image(
    image: AssetImage('images/candlestick-chart.png'),
    height: 130.0,
  ),
);
