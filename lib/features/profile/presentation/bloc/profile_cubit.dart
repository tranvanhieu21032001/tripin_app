import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:wemu_team_app/features/profile/domain/usecases/get_branches_usecase.dart';
import 'package:wemu_team_app/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:wemu_team_app/features/profile/domain/usecases/get_selected_branch_usecase.dart';
import 'package:wemu_team_app/features/profile/domain/usecases/logout_usecase.dart';
import 'package:wemu_team_app/features/profile/domain/usecases/select_branch_usecase.dart';
import 'package:wemu_team_app/features/profile/presentation/bloc/profile_state.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase _getProfile;
  final GetBranchesUseCase _getBranches;
  final GetSelectedBranchUseCase _getSelectedBranch;
  final SelectBranchUseCase _selectBranch;
  final LogoutUseCase _logout;

  ProfileCubit(
    this._getProfile,
    this._getBranches,
    this._getSelectedBranch,
    this._selectBranch,
    this._logout,
  ) : super(const ProfileState());

  Future<void> load() async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final profile = await _getProfile();
      final branches = _getBranches();
      final selected = _getSelectedBranch();
      emit(
        state.copyWith(
          status: ProfileStatus.ready,
          profile: profile,
          branches: branches,
          selectedBranch: selected,
          error: null,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: ProfileStatus.failure,
          error: 'Failed to load profile',
        ),
      );
    }
  }

  Future<void> selectBranch(String branchId) async {
    try {
      await _selectBranch(branchId);
      final selected = _getSelectedBranch();
      emit(state.copyWith(selectedBranch: selected));
    } catch (_) {
      emit(state.copyWith(error: 'Failed to select branch'));
    }
  }

  Future<void> logout() async {
    try {
      await _logout();
      emit(state.copyWith(status: ProfileStatus.loggedOut));
    } catch (_) {
      emit(state.copyWith(error: 'Failed to logout', status: ProfileStatus.failure));
    }
  }
}
