import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:investing/provider/transactions/transactions_provider.dart';
import 'package:investing/screens/authentication/login_screen.dart';
import 'package:provider/provider.dart';
import 'constants.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
      ],
      child: const Investing(),
    ),
  );
}

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
