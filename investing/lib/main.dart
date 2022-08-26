import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:investing/screens/authentication/login_screen.dart';
import 'constants.dart';

void main() {
  runApp(
    const Investing(),
  );
}

// test
class Investing extends StatelessWidget {
  const Investing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(statusBarColor: kColorScheme.surface),
    // );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: kColorScheme, fontFamily: 'Roboto'),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      home: const LoginScreen(),
    );
  }
}
