import 'package:injectable/injectable.dart';
import 'package:wemu_team_app/features/profile/domain/repositories/profile_repository.dart';

@injectable
class SelectBranchUseCase {
  final ProfileRepository _repository;

  SelectBranchUseCase(this._repository);

  Future<void> call(String branchId) => _repository.saveSelectedBranchId(branchId);
}

