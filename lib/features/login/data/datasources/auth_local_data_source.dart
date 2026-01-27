import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wemu_team_app/models/permission.dart';
import 'package:wemu_team_app/models/user_profile.dart';

@lazySingleton
class AuthLocalDataSource {
  static const _tokenKey = 'auth_token';
  static const _emailKey = 'auth_email';
  static const _passwordKey = 'auth_password';
  static const _userKey = 'auth_user';
  static const _permissionsKey = 'auth_permissions';

  final SharedPreferences _prefs;

  AuthLocalDataSource(this._prefs);

  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  String? getToken() => _prefs.getString(_tokenKey);

  Future<void> saveUser(UserProfile user) async {
    await _prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  UserProfile? getUser() {
    final raw = _prefs.getString(_userKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      return null;
    }
    return UserProfile.fromJson(decoded);
  }

  Future<void> savePermissions(List<Permission> permissions) async {
    final payload = permissions.map((e) => e.toJson()).toList();
    await _prefs.setString(_permissionsKey, jsonEncode(payload));
  }

  List<Permission> getPermissions() {
    final raw = _prefs.getString(_permissionsKey);
    if (raw == null || raw.isEmpty) {
      return const <Permission>[];
    }
    final decoded = jsonDecode(raw);
    if (decoded is! List) {
      return const <Permission>[];
    }
    return decoded
        .whereType<Map>()
        .map((e) => Permission.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> saveCredentials({
    required String email,
    required String password,
  }) async {
    await _prefs.setString(_emailKey, email);
    await _prefs.setString(_passwordKey, password);
  }

  ({String email, String password})? getSavedCredentials() {
    final email = _prefs.getString(_emailKey);
    final password = _prefs.getString(_passwordKey);
    if (email == null || password == null) {
      return null;
    }
    return (email: email, password: password);
  }

  Future<void> clearCredentials() async {
    await _prefs.remove(_emailKey);
    await _prefs.remove(_passwordKey);
  }

  Future<void> clearToken() async {
    await _prefs.remove(_tokenKey);
  }

  Future<void> clearUser() async {
    await _prefs.remove(_userKey);
  }

  Future<void> clearPermissions() async {
    await _prefs.remove(_permissionsKey);
  }
}
