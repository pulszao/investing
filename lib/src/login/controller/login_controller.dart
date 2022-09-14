import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  String? _username;
  String? _password;
  String? _version = '1.0.0';

  void setVersion(String? version) {
    _version = version;
    notifyListeners();
  }

  String? getVersion() {
    return _version;
  }

  void setUsername(String? username) {
    _username = username;
    notifyListeners();
  }

  String? getUsername() {
    return _username;
  }

  void setPassword(String? password) {
    _password = password;
    notifyListeners();
  }

  String? getPassword() {
    return _password;
  }
}
