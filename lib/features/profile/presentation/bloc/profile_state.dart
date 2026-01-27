import 'package:wemu_team_app/features/profile/data/models/profile.dart';
import 'package:wemu_team_app/models/branch.dart';

enum ProfileStatus { initial, loading, ready, failure, loggedOut }

class ProfileState {
  final ProfileStatus status;
  final Profile? profile;
  final List<Branch> branches;
  final Branch? selectedBranch;
  final String? error;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.branches = const <Branch>[],
    this.selectedBranch,
    this.error,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    Profile? profile,
    List<Branch>? branches,
    Branch? selectedBranch,
    String? error,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      branches: branches ?? this.branches,
      selectedBranch: selectedBranch ?? this.selectedBranch,
      error: error,
    );
  }
}

