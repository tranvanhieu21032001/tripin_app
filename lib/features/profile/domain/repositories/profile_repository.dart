import 'package:wemu_team_app/features/profile/data/models/profile.dart';
import 'package:wemu_team_app/models/branch.dart';

abstract class ProfileRepository {
  Future<Profile> getProfile();

  List<Branch> getBranches();

  Branch? getSelectedBranch();

  Future<void> saveSelectedBranchId(String branchId);

  Future<void> changePassword({
    required String oldPasswordMd5,
    required String newPasswordMd5,
  });

  Future<void> logout();
}

