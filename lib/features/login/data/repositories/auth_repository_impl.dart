import 'package:injectable/injectable.dart';

import '../../domain/repositories/auth_repository.dart';
import 'package:wemu_team_app/models/permission.dart';
import 'package:wemu_team_app/models/user_profile.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  AuthRepositoryImpl(this._remote, this._local);

  @override
  Future<String> login({
    required String email,
    required String passwordMd5,
  }) async {
    final response = await _remote.login(
      email: email,
      passwordMd5: passwordMd5,
    );
    await _local.saveToken(response.token);
    await _local.saveUser(response.user);
    await _local.savePermissions(response.permissions);
    return response.token;
  }

  @override
  Future<void> saveCredentials({
    required String email,
    required String password,
  }) async {
    await _local.saveCredentials(email: email, password: password);
  }

  @override
  Future<void> clearCredentials() async {
    await _local.clearCredentials();
  }

  @override
  ({String email, String password})? getSavedCredentials() {
    return _local.getSavedCredentials();
  }

  @override
  String? getCachedToken() => _local.getToken();

  @override
  UserProfile? getCachedUser() => _local.getUser();

  @override
  List<Permission> getCachedPermissions() => _local.getPermissions();
}
