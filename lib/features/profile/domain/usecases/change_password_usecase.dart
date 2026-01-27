import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:injectable/injectable.dart';
import 'package:wemu_team_app/features/profile/domain/repositories/profile_repository.dart';

@injectable
class ChangePasswordUseCase {
  final ProfileRepository _repository;

  ChangePasswordUseCase(this._repository);

  Future<void> call({
    required String currentPassword,
    required String newPassword,
  }) async {
    final oldPasswordMd5 = md5.convert(utf8.encode(currentPassword)).toString();
    final newPasswordMd5 = md5.convert(utf8.encode(newPassword)).toString();

    return _repository.changePassword(
      oldPasswordMd5: oldPasswordMd5,
      newPasswordMd5: newPasswordMd5,
    );
  }
}
