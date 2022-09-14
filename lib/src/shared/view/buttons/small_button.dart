import 'package:flutter/material.dart';
import 'package:investing/src/constants.dart';

class SmallButton extends StatelessWidget {
  final String? text;
  final Color? backgroundColor;
  final Color? textColor;
  final void Function() onPressed;
  final IconData? materialIcon;
  final double? width;
  final double? elevation;
  final bool? disabled;

  const SmallButton({
    Key? key,
    this.text,
    this.backgroundColor,
    this.textColor,
    required this.onPressed,
    this.materialIcon,
    this.width,
    this.elevation,
    this.disabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Material(
        elevation: elevation ?? 2,
        color: disabled! ? kDisabledButtonColor : backgroundColor,
        borderRadius: BorderRadius.circular(5.0),
        child: MaterialButton(
          onPressed: disabled! ? null : onPressed,
          minWidth: 100.0,
          height: 42.0,
          child: Text(
            text!,
            style: kBaseTextStyle(
              color: textColor,
              fontSize: 13.0,
            ),
          ),
        ),
      ),
    );
  }
}
