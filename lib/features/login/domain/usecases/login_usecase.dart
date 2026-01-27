import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:injectable/injectable.dart';

import '../repositories/auth_repository.dart';

@injectable
class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<String> call({
    required String email,
    required String password,
  }) async {
    final passwordMd5 = md5.convert(utf8.encode(password)).toString();
    return _repository.login(email: email, passwordMd5: passwordMd5);
  }
}
