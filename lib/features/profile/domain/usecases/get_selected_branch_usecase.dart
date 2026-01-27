import 'package:injectable/injectable.dart';
import 'package:wemu_team_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:wemu_team_app/models/branch.dart';

@injectable
class GetSelectedBranchUseCase {
  final ProfileRepository _repository;

  GetSelectedBranchUseCase(this._repository);

  Branch? call() => _repository.getSelectedBranch();
}

