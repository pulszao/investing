import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:investing/src/constants.dart';
import 'package:investing/src/menu/view/menu_screen.dart';
import 'package:investing/src/shared/view/buttons/button.dart';
import 'package:provider/provider.dart';

import '../controller/login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final loginKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String? version = Provider.of<LoginProvider>(context, listen: false).getVersion();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // dismiss keyboard
      child: Scaffold(
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'v$version',
                        textAlign: TextAlign.center,
                        style: kBaseTextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Platform.isAndroid ? 10 : 0),
                ],
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Form(
                    key: loginKey,
                    child: Column(
                      children: [
                        const Image(
                          image: AssetImage('images/candlestick-chart.png'),
                          height: 130.0,
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          enableSuggestions: false,
                          decoration: const InputDecoration(
                            label: Text('Usename'),
                            focusedBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(width: 4, color: Colors.blue),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(width: 2, color: Colors.blue),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (username) => Provider.of<LoginProvider>(context, listen: false).setUsername(username),
                          validator: (username) {
                            String? username = Provider.of<LoginProvider>(context, listen: false).getUsername();
                            if (username == null) {
                              return 'Insira sua senha.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: const InputDecoration(
                            label: Text('Password'),
                            focusedBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(width: 4, color: Colors.blue),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(width: 2, color: Colors.blue),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          onChanged: (password) => Provider.of<LoginProvider>(context, listen: false).setPassword(password),
                          validator: (password) {
                            String? password = Provider.of<LoginProvider>(context, listen: false).getPassword();
                            if (password == null) {
                              return 'Insira sua senha.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Button(
                          onPressed: () {
                            if (loginKey.currentState!.validate()) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (BuildContext context) => const MenuScreen()),
                                (Route<dynamic> route) => false,
                              );
                            }
                          },
                          width: 300,
                          text: 'Login',
                          elevation: 0,
                          backgroundColor: kColorScheme.primary,
                          textColor: Colors.white,
                        ),
                        Button(
                          onPressed: () {},
                          width: 300,
                          text: 'Register',
                          elevation: 0,
                          backgroundColor: kColorScheme.onPrimary,
                          textColor: kColorScheme.primary,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).viewInsets.bottom == 0 ? 120 : 0,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
