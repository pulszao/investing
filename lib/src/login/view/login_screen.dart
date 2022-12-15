import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:investing/src/constants.dart';
import 'package:investing/src/login/view/registration_screen.dart';
import 'package:investing/src/menu/view/menu_screen.dart';
import 'package:investing/src/profile/controller/profile_controller.dart';
import 'package:investing/src/shared/view/buttons/button.dart';
import 'package:investing/src/shared/view/modals/scaffold_modal.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    FirebaseAuth.instance.idTokenChanges().listen((User? user) {
      if (user != null) {
        String? username = user.displayName ?? user.email;
        Provider.of<ProfileProvider>(context, listen: false).setInitials(username);
        Provider.of<ProfileProvider>(context, listen: false).setDisplayName(username);
        Provider.of<ProfileProvider>(context, listen: false).setEmail(user.email);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => const MenuScreen()),
          (Route<dynamic> route) => false,
        );
      }
    });

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
                        loginLogoImage,
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
                            String username = Provider.of<LoginProvider>(context, listen: false).getUsername();
                            if (username == '') {
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
                            String password = Provider.of<LoginProvider>(context, listen: false).getPassword();
                            if (password == '') {
                              return 'Insira sua senha.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Button(
                          onPressed: () async {
                            if (loginKey.currentState!.validate()) {
                              // register user
                              int authentication = await authenticateUser(
                                email: Provider.of<LoginProvider>(context, listen: false).getUsername(),
                                password: Provider.of<LoginProvider>(context, listen: false).getPassword(),
                              );
                              if (!mounted) return;

                              if (authentication == 0) {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (BuildContext context) => const MenuScreen()),
                                  (Route<dynamic> route) => false,
                                );
                              } else if (authentication == 1) {
                                // error scaffold modal
                                showScaffoldModal(
                                  context: context,
                                  message: "Wrong password.",
                                  duration: 2,
                                );
                              } else if (authentication == 2) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => RegistrationScreen(
                                      email: Provider.of<LoginProvider>(context, listen: false).getUsername(),
                                    ),
                                  ),
                                );
                                // error scaffold modal
                                showScaffoldModal(
                                  backgroundColor: kWarningColor,
                                  context: context,
                                  message: "Username not registered yet!",
                                  duration: 2,
                                );
                              } else {
                                // error scaffold modal
                                showScaffoldModal(
                                  context: context,
                                  message: "We had a problem on your login, try again.",
                                  duration: 2,
                                );
                              }
                            }
                          },
                          width: 300,
                          text: 'Login',
                          elevation: 0,
                          backgroundColor: kColorScheme.primary,
                          textColor: Colors.white,
                        ),
                        Button(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (BuildContext context) => const RegistrationScreen()),
                          ),
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
