import 'package:flutter/material.dart';
import 'package:investing/src/constants.dart';

class CardItemModel {
  final String description;
  final IconData? iconData;
  final VoidCallback? onPressed;

  CardItemModel({
    required this.description,
    this.iconData,
    this.onPressed,
  });
}

class MenuCardWidget extends StatelessWidget {
  final double screenWidth;
  final Color? circleAvatarBackgroundColor = kColorScheme.primary.withOpacity(0.4);
  final CardItemModel itemModel;

  MenuCardWidget({
    Key? key,
    required this.screenWidth,
    required this.itemModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: kColorScheme.surface,
        onPrimary: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        textStyle: kBaseTextStyle(fontSize: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        minimumSize: const Size(70, 70),
        maximumSize: Size(screenWidth / 3.3, 115),
      ),
      onPressed: itemModel.onPressed,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: circleAvatarBackgroundColor,
              radius: 30.0,
              child: Icon(
                itemModel.iconData,
                color: kColorScheme.primary,
                size: 27,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              itemModel.description,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
