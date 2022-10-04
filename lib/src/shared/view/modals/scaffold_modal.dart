import 'package:flutter/material.dart';
import '../../../constants.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showScaffoldModal({
  required BuildContext context,
  required String message,
  required int duration,
  Color? backgroundColor,
  Color? textColor,
}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      dismissDirection: DismissDirection.down,
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: duration),
      backgroundColor: backgroundColor ?? kColorScheme.error,
      content: Text(
        message,
        style: kBaseTextStyle(
          fontSize: 15,
          color: textColor ?? Colors.white,
        ),
      ),
    ),
  );
}
