import 'package:injectable/injectable.dart';
import 'package:wemu_team_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:wemu_team_app/models/branch.dart';

@injectable
class GetBranchesUseCase {
  final ProfileRepository _repository;

  GetBranchesUseCase(this._repository);

  List<Branch> call() => _repository.getBranches();
}

