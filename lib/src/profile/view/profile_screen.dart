import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:investing/src/login/view/login_screen.dart';
import 'package:investing/src/profile/controller/profile_controller.dart';
import 'package:investing/src/profile/view/profile_edit_screen.dart';
import 'package:investing/src/shared/view/buttons/button.dart';
import 'package:investing/src/shared/view/modals/bottom_sheet_modal.dart';
import 'package:provider/provider.dart';
import 'package:investing/src/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    String? username = Provider.of<ProfileProvider>(context).getDisplayName();
    String? email = Provider.of<ProfileProvider>(context).getEmail();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) => const ProfileEditScreen()),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith((_) => kColorScheme.surface),
                          foregroundColor: MaterialStateColor.resolveWith((_) => kColorScheme.onSurface),
                        ),
                        child: const Text('Edit'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    username ?? 'user',
                    style: kBaseTextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(top: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Email',
                              style: kBaseTextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                            const SizedBox(width: 12.0),
                            Expanded(
                              child: Text(
                                email ?? '',
                                style: kBaseTextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(color: Colors.grey),
                        const SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Button(
                        onPressed: () {
                          showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return BottomSheetModal(
                                maxHeight: MediaQuery.of(context).size.height * 0.65,
                                backgroundColor: kModalBackgroundColor,
                                body: [
                                  Text(
                                    'See you later...',
                                    style: kBaseTextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Are you sure you want to logout the app?',
                                    style: kBaseTextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Button(
                                        onPressed: () async {
                                          await FirebaseAuth.instance.signOut();

                                          if (!mounted) return;
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(builder: (BuildContext context) => const LoginScreen()),
                                            (Route<dynamic> route) => false,
                                          );
                                        },
                                        text: 'Confirm',
                                        width: 100,
                                        backgroundColor: kColorScheme.surface,
                                      ),
                                      const SizedBox(width: 30),
                                      Button(
                                        onPressed: () => Navigator.pop(context),
                                        text: 'Cancel',
                                        width: 100,
                                        backgroundColor: kColorScheme.surface,
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        text: 'Logout',
                        width: 100,
                        materialIcon: Icons.logout,
                        backgroundColor: kColorScheme.surface,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Data provider for free via EDX Cloud API.',
                    textAlign: TextAlign.center,
                    style: kBaseTextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Visit their website to see terms of use.',
                    textAlign: TextAlign.center,
                    style: kBaseTextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
