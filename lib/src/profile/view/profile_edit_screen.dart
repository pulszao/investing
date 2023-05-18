import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:investing/src/constants.dart';
import 'package:investing/src/profile/controller/profile_controller.dart';
import 'package:investing/src/shared/view/modals/loading_modal.dart';
import 'package:investing/src/shared/view/modals/scaffold_modal.dart';
import 'package:provider/provider.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  String newUsername = '';
  DateTime now = DateTime.now();
  User? authUser = FirebaseAuth.instance.currentUser;
  final _profileEditKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String? username = Provider.of<ProfileProvider>(context).getDisplayName();
    String? email = Provider.of<ProfileProvider>(context).getEmail();

    return Scaffold(
      backgroundColor: kColorScheme.background,
      appBar: kBaseAppBar(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 40.0),
          child: Form(
            key: _profileEditKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () async {
                        if (_profileEditKey.currentState!.validate()) {
                          loadingModalCall(context);
                          await authUser!.updateDisplayName(newUsername);
                          if (!mounted) return;
                          Navigator.pop(context); // pop loading modal
                          Provider.of<ProfileProvider>(context, listen: false).setDisplayName(newUsername);
                          Provider.of<ProfileProvider>(context, listen: false).setInitials(newUsername);
                          // scaffold success modal
                          showScaffoldModal(
                            backgroundColor: kSuccessColor,
                            context: context,
                            message: "Display name updated!",
                            duration: 2,
                          );
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith((_) => kColorScheme.surface),
                        foregroundColor: MaterialStateColor.resolveWith((_) => kColorScheme.onSurface),
                      ),
                      child: const Text('Save'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Display Name',
                    helperStyle: kBaseTextStyle(
                      fontSize: 12.0,
                    ),
                    helperMaxLines: 2,
                    counterText: '',
                  ),
                  initialValue: username,
                  onChanged: (String name) {
                    setState(() {
                      newUsername = name;
                    });
                  },
                  maxLength: 60,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Your name cant be blank.';
                    } else if (!value.contains(' ')) {
                      return 'Enter your first and last name.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  enabled: false,
                  decoration: InputDecoration(
                    helperText: "Your email address can't be changed.",
                    labelText: 'Email',
                    helperStyle: kBaseTextStyle(
                      fontSize: 12.0,
                    ),
                    helperMaxLines: 2,
                    counterText: '',
                  ),
                  initialValue: email,
                  onChanged: (String name) {},
                  maxLength: 60,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Your email cant be blank.';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
