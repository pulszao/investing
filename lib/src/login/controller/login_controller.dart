import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  String _username = '';
  String _password = '';
  String _passwordConfirmation = '';
  String? _version = '1.0.0';

  void setVersion(String? version) {
    _version = version;
    notifyListeners();
  }

  String? getVersion() {
    return _version;
  }

  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  String getUsername() {
    return _username;
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  String getPassword() {
    return _password;
  }

  void setPasswordConfirmation(String password) {
    _passwordConfirmation = password;
    notifyListeners();
  }

  String getPasswordConfirmation() {
    return _passwordConfirmation;
  }
}

Future<int> registerUser({required String email, required String password}) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    return 0;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      // print('The password provided is too weak.');
      return 1;
    } else if (e.code == 'email-already-in-use') {
      // print('The account already exists for that email.');
      return 2;
    }
  } catch (e) {
    // print(e);
    return 3;
  }
  return 3;
}

Future<int> authenticateUser({required String email, required String password}) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    return 0;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      // print('No user found for that email.');
      return 2;
    } else if (e.code == 'wrong-password') {
      // print('Wrong password provided for that user.');
      return 1;
    }
  } catch (e) {
    // print(e);
    return 3;
  }
  return 3;
}
