import 'package:flutter/material.dart';
import 'package:investing/src/constants.dart';
import 'package:investing/src/menu/view/menu_screen.dart';
import 'package:investing/src/shared/view/buttons/button.dart';
import 'package:investing/src/shared/view/modals/scaffold_modal.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../controller/login_controller.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final registrationKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // dismiss keyboard
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Form(
                  key: registrationKey,
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
                          if (registrationKey.currentState!.validate()) {
                            // register user
                            int registration = await registerUser(
                              email: Provider.of<LoginProvider>(context, listen: false).getUsername(),
                              password: Provider.of<LoginProvider>(context, listen: false).getPassword(),
                            );
                            if (!mounted) return;

                            if (registration == 0) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (BuildContext context) => const MenuScreen()),
                                (Route<dynamic> route) => false,
                              );
                            } else if (registration == 1) {
                              // error scaffold modal
                              showScaffoldModal(
                                context: context,
                                message: "Your password is too weak.",
                                duration: 2,
                              );
                            } else if (registration == 2) {
                              // error scaffold modal
                              showScaffoldModal(
                                context: context,
                                message: "Username already taken.",
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
                        text: 'Register',
                        elevation: 0,
                        backgroundColor: kColorScheme.primary,
                        textColor: Colors.white,
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
        ),
      ),
    );
  }
}
