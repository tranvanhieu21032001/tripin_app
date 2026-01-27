import 'package:wemu_team_app/models/user_profile.dart';
import 'package:wemu_team_app/models/permission.dart';

abstract class AuthRepository {
  Future<String> login({
    required String email,
    required String passwordMd5,
  });

  Future<void> saveCredentials({
    required String email,
    required String password,
  });

  Future<void> clearCredentials();

  ({String email, String password})? getSavedCredentials();

  String? getCachedToken();

  UserProfile? getCachedUser();

  List<Permission> getCachedPermissions();
}
