import 'package:flutter/material.dart';

Future<dynamic> loadingModalCall(BuildContext context) async {
  return await showGeneralDialog(
    barrierDismissible: false,
    context: context,
    pageBuilder: (context, anim1, anim2) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            LoadingModal(),
          ],
        ),
      );
    },
  );
}

class LoadingModal extends StatelessWidget {
  const LoadingModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).textScaleFactor == 1.3 ? 153.0 : 165.0,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            SizedBox(width: 10.0),
            AlertDialog(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              content: CircularProgressIndicator(
                strokeWidth: 3.0,
                backgroundColor: Colors.transparent,
              ),
            ),
            SizedBox(width: 10.0),
          ],
        ),
      ),
    );
  }
}
