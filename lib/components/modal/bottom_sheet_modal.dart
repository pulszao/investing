import 'package:flutter/material.dart';
import 'package:investing/constants.dart';

class BottomSheetModal extends StatefulWidget {
  final String? isOnline;
  final Gradient? backgroundGradient;
  final Color? backgroundColor;
  final List<Widget> body;
  final double maxHeight;
  final Widget? bottomWidget;
  final Widget? topWidget;
  final CrossAxisAlignment bodyAlignment;

  const BottomSheetModal({
    Key? key,
    this.isOnline,
    this.backgroundGradient,
    this.backgroundColor,
    required this.body,
    required this.maxHeight,
    this.bottomWidget,
    this.topWidget,
    this.bodyAlignment = CrossAxisAlignment.start,
  }) : super(key: key);

  @override
  State<BottomSheetModal> createState() => _BottomSheetModalState();
}

class _BottomSheetModalState extends State<BottomSheetModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: widget.backgroundColor == null
          ? BoxDecoration(
              gradient: widget.backgroundGradient,
            )
          : BoxDecoration(
              color: widget.backgroundColor,
            ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: widget.maxHeight,
          minHeight: 10,
        ),
        decoration: BoxDecoration(
          color: kColorScheme.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30),
                child: Column(
                  crossAxisAlignment: widget.bodyAlignment,
                  mainAxisSize: MainAxisSize.min,
                  children: widget.body,
                ),
              ),
            ),
            widget.topWidget != null
                ? Align(
                    alignment: AlignmentDirectional.topCenter,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      constraints: BoxConstraints(
                        maxHeight: widget.maxHeight,
                        minHeight: 10,
                      ),
                      child: widget.topWidget,
                    ),
                  )
                : const SizedBox(),
            widget.bottomWidget != null
                ? Align(
                    alignment: AlignmentDirectional.bottomEnd,
                    child: Container(
                      constraints: BoxConstraints(
                        maxHeight: widget.maxHeight,
                        minHeight: 10,
                      ),
                      child: widget.bottomWidget,
                    ),
                  )
                : const SizedBox(),
            Container(
              height: 20,
              constraints: BoxConstraints(
                maxHeight: widget.maxHeight,
                minHeight: 10,
              ),
              decoration: BoxDecoration(
                color: kColorScheme.background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 6,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: const BorderRadius.all(Radius.circular(23.0)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
