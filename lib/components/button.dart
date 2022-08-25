import 'package:flutter/material.dart';
import '../../constants.dart';

class Button extends StatelessWidget {
  final String? text;
  final Color? backgroundColor;
  final Color? textColor;
  final String? icon;
  final IconData? materialIcon;
  final void Function() onPressed;
  final double? width;
  final double? elevation;

  const Button({
    Key? key,
    this.text,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.materialIcon,
    required this.onPressed,
    this.width = 200,
    this.elevation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      height: 57,
      child: Material(
        elevation: elevation ?? 5.0,
        color: backgroundColor,
        borderRadius: BorderRadius.circular(5.0),
        child: MaterialButton(
          onPressed: onPressed,
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    icon != null
                        ? Image.asset(
                            icon!,
                            width: 18.0,
                          )
                        : const SizedBox(),
                    icon != null
                        ? const SizedBox(
                            width: 7.0,
                          )
                        : const SizedBox(),
                    materialIcon != null
                        ? Icon(
                            materialIcon,
                            size: 20.0,
                            color: textColor,
                          )
                        : const SizedBox(),
                    materialIcon != null
                        ? const SizedBox(
                            width: 7.0,
                          )
                        : const SizedBox(),
                    Text(
                      text!,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: kBaseTextStyle(
                        color: textColor,
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
