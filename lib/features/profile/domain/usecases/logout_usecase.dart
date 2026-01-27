import 'package:wemu_team_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class LogoutUseCase {
  final ProfileRepository _repository;

  LogoutUseCase(this._repository);

  Future<void> call() => _repository.logout();
}


