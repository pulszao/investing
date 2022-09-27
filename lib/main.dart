import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:investing/src/login/controller/login_controller.dart';
import 'package:investing/src/login/view/login_screen.dart';
import 'package:investing/src/menu/controller/menu_controller.dart';
import 'package:investing/src/transactions/controller/transactions_controller.dart';
import 'package:investing/src/watchlist/controller/watchlist_controller.dart';
import 'package:provider/provider.dart';
import 'src/constants.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => WatchlistProvider()),
        ChangeNotifierProvider(create: (_) => MenuProvider()),
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
