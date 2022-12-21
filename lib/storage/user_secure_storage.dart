import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  static const _storage = FlutterSecureStorage();

  static const _userEmail = 'userEmail';
  static const _userPassword = 'userPassword';

  static Future setUserEmail(String? data) async => await _storage.write(key: _userEmail, value: data);

  static Future<String?> getUserEmail() async => await _storage.read(key: _userEmail);

  static Future setUserPassword(String? data) async => await _storage.write(key: _userPassword, value: data);

  static Future<String?> getUserPassword() async => await _storage.read(key: _userPassword);
}
