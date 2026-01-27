import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wemu_team_app/features/login/domain/repositories/auth_repository.dart';
import 'package:wemu_team_app/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:wemu_team_app/features/profile/data/models/profile.dart';
import 'package:wemu_team_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:wemu_team_app/models/branch.dart';
import 'package:wemu_team_app/models/permission.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  static const String selectedBranchKey = 'selected_branch_id';

  final AuthRepository _authRepository;
  final SharedPreferences _prefs;
  final ProfileRemoteDataSource _remote;

  ProfileRepositoryImpl(
    this._authRepository,
    this._prefs,
    this._remote,
  );

  List<Permission> _permissions() => _authRepository.getCachedPermissions();

  String _readString(Map<String, dynamic>? root, List<String> path) {
    if (root == null) return '';
    dynamic current = root;
    for (final key in path) {
      if (current is! Map<String, dynamic>) return '';
      final value = current[key];
      if (key == path.last) {
        return value is String ? value : '';
      }
      current = value;
    }
    return '';
  }

  @override
  Future<Profile> getProfile() async {
    final business = await _remote.getBusinessInfo();
    final userMapDynamic = business['employee'] ?? business['manager'];
    final userMap = userMapDynamic is Map
        ? Map<String, dynamic>.from(userMapDynamic as Map)
        : <String, dynamic>{};

    final cachedUser = _authRepository.getCachedUser();
    final selectedBranch = getSelectedBranch();

    final firstName =
        (userMap['firstName'] as String?) ?? cachedUser?.firstName ?? '';
    final lastName =
        (userMap['lastName'] as String?) ?? cachedUser?.lastName ?? '';
    final fullName = [firstName, lastName]
        .where((p) => p.trim().isNotEmpty)
        .join(' ')
        .trim();

    final email =
        (userMap['email'] as String?) ?? cachedUser?.email ?? '';
    final avatar =
        (userMap['avatar'] as String?) ?? cachedUser?.avatar ?? '';
    final avatarUrl = avatar.isEmpty ? null : avatar;

    final mobile = (userMap['phone'] as String?)?.trim() ?? '';

    final address = (userMap['address'] as String?) ?? '';

    return Profile(
      fullName: fullName.isEmpty
          ? (cachedUser?.displayNameOrGuest ?? 'Guest')
          : fullName,
      email: email,
      branchName: selectedBranch?.name ?? 'Makati Branch',
      avatarUrl: avatarUrl,
      firstName: firstName,
      lastName: lastName,
      mobile: mobile,
      birthdayLabel: '',
      gender: '',
      address: address,
    );
  }

  @override
  List<Branch> getBranches() {
    final permissions = _permissions();
    if (permissions.isNotEmpty) {
      final branches = permissions.first.branches;
      if (branches.isNotEmpty) return branches;
    }
    return const <Branch>[];
  }

  @override
  Branch? getSelectedBranch() {
    final branches = getBranches();
    if (branches.isEmpty) return null;

    final savedId = _prefs.getString(selectedBranchKey);
    if (savedId == null || savedId.isEmpty) {
      final defaultBranch = branches.where((b) => b.isDefault).toList();
      return defaultBranch.isNotEmpty ? defaultBranch.first : branches.first;
    }

    try {
      return branches.firstWhere((b) => b.id == savedId);
    } catch (_) {
      return branches.first;
    }
  }

  @override
  Future<void> saveSelectedBranchId(String branchId) async {
    await _prefs.setString(selectedBranchKey, branchId);
  }

  @override
  Future<void> changePassword({
    required String oldPasswordMd5,
    required String newPasswordMd5,
  }) {
    return _remote.changePassword(
      oldPasswordMd5: oldPasswordMd5,
      newPasswordMd5: newPasswordMd5,
    );
  }

  @override
  Future<void> logout() async {
    await _authRepository.clearCredentials();
    await _prefs.remove('auth_token');
    await _prefs.remove('auth_user');
    await _prefs.remove('auth_permissions');
    await _prefs.remove('auth_email');
    await _prefs.remove('auth_password');
    await _prefs.remove(selectedBranchKey);
  }
}

