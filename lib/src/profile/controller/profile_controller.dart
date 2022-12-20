import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  String? _email = '';
  String? _displayName = '';
  String? _initials = '';

  String? getEmail() {
    return _email;
  }

  void setEmail(String? email) {
    _email = email;
    notifyListeners();
  }

  String? getDisplayName() {
    return _displayName;
  }

  void setDisplayName(String? name) {
    _displayName = name;
    notifyListeners();
  }

  String? getInitials() {
    return _initials;
  }

  void setInitials(String? username) {
    if (username != '') {
      List<String> splitString = username!.toUpperCase().split(' ');
      if (splitString.length > 1) {
        _initials = splitString[0][0] + splitString[1][0];
      } else {
        _initials = splitString[0][0];
      }
      notifyListeners();
    }
  }
}
