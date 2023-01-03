import 'package:flutter/material.dart';
import 'package:investing/src/constants.dart';
import 'package:investing/src/profile/controller/profile_controller.dart';
import 'package:provider/provider.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {},
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
                onChanged: (String name) {},
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
    );
  }
}
