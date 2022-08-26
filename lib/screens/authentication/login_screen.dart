import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:investing/components/button/button.dart';
import '../../constants.dart';
import '../menu_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String email;
  late String password;
  final _loginKey = GlobalKey<FormState>();
  String? version = '1.0.0';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _loginKey,
        child: Stack(
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
            GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(), // dismiss keyboard
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Column(
                      children: [
                        const Image(
                          image: AssetImage('images/candlestick-chart.png'),
                          height: 130.0,
                        ),
                        const SizedBox(height: 15),

                        // TODO: login user
                        TextFormField(
                          enableSuggestions: false,
                          decoration: const InputDecoration(
                            label: Text('Usuário'),
                            focusedBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(width: 4, color: Colors.blue),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(width: 2, color: Colors.blue),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (username) {},
                          validator: (username) {
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: const InputDecoration(
                            label: Text('Senha'),
                            focusedBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(width: 4, color: Colors.blue),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(width: 2, color: Colors.blue),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          onChanged: (password) {},
                          validator: (password) {
                            if (password == null) {
                              return 'Insira sua senha.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Button(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (BuildContext context) => const MenuScreen()),
                              (Route<dynamic> route) => false,
                            );
                          },
                          width: 300,
                          text: 'Entrar',
                          elevation: 0,
                          backgroundColor: kColorScheme.primary,
                          textColor: Colors.white,
                        ),
                        Button(
                          onPressed: () {},
                          width: 300,
                          text: 'Registrar-se',
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
