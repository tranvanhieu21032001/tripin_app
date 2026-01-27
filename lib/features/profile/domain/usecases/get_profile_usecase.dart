import 'package:injectable/injectable.dart';
import 'package:wemu_team_app/features/profile/data/models/profile.dart';
import 'package:wemu_team_app/features/profile/domain/repositories/profile_repository.dart';

@injectable
class GetProfileUseCase {
  final ProfileRepository _repository;

  GetProfileUseCase(this._repository);

  Future<Profile> call() {
    return _repository.getProfile();
  }
}

