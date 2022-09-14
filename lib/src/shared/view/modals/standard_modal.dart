import 'package:flutter/material.dart';
import '../../../constants.dart';

class StandardModal extends StatefulWidget {
  final String? label;
  final String? body;
  final Widget? bodyWidget;
  final String? confirmButtonLabel;
  final void Function()? confirmButtonFunction;
  final bool? displayConfirmationButton;
  final bool? displayCancelButton;
  final TextAlign? labelAlign;

  const StandardModal({
    Key? key,
    this.label,
    this.body,
    this.bodyWidget,
    this.confirmButtonLabel,
    this.confirmButtonFunction,
    this.displayConfirmationButton,
    this.displayCancelButton,
    this.labelAlign,
  }) : super(key: key);

  @override
  State<StandardModal> createState() => _StandardModalState();
}

class _StandardModalState extends State<StandardModal> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    // controla animação do popup/alert
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
    scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: Column(
        children: [
          const Expanded(child: SizedBox()),
          AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(23.0))),
            content: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              child: Column(
                children: [
                  Text(
                    '${widget.label}',
                    textAlign: widget.labelAlign ?? TextAlign.justify,
                    overflow: TextOverflow.visible,
                    style: kBaseTextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  widget.body != null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${widget.body}',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.visible,
                            style: kBaseTextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                        )
                      : const SizedBox(),
                  widget.bodyWidget != null ? widget.bodyWidget! : const SizedBox(),
                ],
              ),
            ),
            actions: [
              widget.displayCancelButton == false
                  ? const SizedBox()
                  : TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancelar'),
                    ),
              widget.displayConfirmationButton == false
                  ? const SizedBox()
                  : TextButton(
                      onPressed: widget.confirmButtonFunction,
                      child: Text(
                        '${widget.confirmButtonLabel}',
                      ),
                    ),
            ],
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}
