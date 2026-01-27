import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wemu_team_app/core/configs/assets/app_images.dart';
import 'package:wemu_team_app/core/configs/theme/app_colors.dart';
import 'package:wemu_team_app/core/di/injection.dart';
import 'package:wemu_team_app/features/login/login_page.dart';
import 'package:wemu_team_app/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:wemu_team_app/features/profile/presentation/bloc/profile_state.dart';
import 'package:wemu_team_app/features/profile/pages/pin_password_page.dart';
import 'package:wemu_team_app/features/profile/pages/profile_detail_page.dart';
import 'package:wemu_team_app/features/profile/widgets/branch_select_bottom_sheet.dart';

class ProfileOverviewPage extends StatelessWidget {
  const ProfileOverviewPage({super.key});

  void _openBranchSelector({
    required BuildContext context,
    required ProfileState state,
    required ProfileCubit cubit,
  }) {
    if (state.branches.isEmpty) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.7,
          child: BranchSelectBottomSheet(
            branches: state.branches,
            selectedBranchId: state.selectedBranch?.id,
            onSelected: (branch) => cubit.selectBranch(branch.id),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfileCubit>()..load(),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state.status == ProfileStatus.loggedOut) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (_) => false,
            );
          }
          if (state.status == ProfileStatus.failure && state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!)),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<ProfileCubit>();
          final profile = state.profile;
          final avatarProvider = (profile?.avatarUrl ?? '').isNotEmpty
              ? NetworkImage(profile!.avatarUrl!)
              : const AssetImage(AppImages.avatar) as ImageProvider;

          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.grey),
                onPressed: () => Navigator.of(context).pop(),
              ),
              centerTitle: false,
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    CircleAvatar(radius: 32, backgroundImage: avatarProvider),
                    const SizedBox(height: 12),
                    Text(
                      profile?.fullName ?? '',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile?.email ?? '',
                      style: const TextStyle(fontSize: 14, color: AppColors.black),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _openBranchSelector(
                        context: context,
                        state: state,
                        cubit: cubit,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFa8a8a8),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              state.selectedBranch?.name ?? profile?.branchName ?? '',
                              style: const TextStyle(fontSize: 12, color: AppColors.white),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.expand_more, size: 16, color: AppColors.white),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListView(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Earnings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                              trailing: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E61F5),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Text(
                                  '\$123,232.00 total',
                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ),
                              onTap: () {},
                            ),
                            const Divider(thickness: 0.3, height: 1, color: AppColors.lightGrey),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Timesheet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                              trailing:
                                  const Icon(Icons.chevron_right, color: AppColors.grey),
                              onTap: () {},
                            ),
                            const Divider(thickness: 0.3, height: 1, color: AppColors.lightGrey),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Profile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                              trailing:
                                  const Icon(Icons.chevron_right, color: AppColors.grey),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const ProfileDetailPage(),
                                  ),
                                );
                              },
                            ),
                            const Divider(thickness: 0.3, height: 1, color: AppColors.lightGrey),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Pin & Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                              trailing:
                                  const Icon(Icons.chevron_right, color: AppColors.grey),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const PinPasswordPage(),
                                  ),
                                );
                              },
                            ),
                            const Divider(thickness: 0.3, height: 1, color: AppColors.lightGrey),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Log Out',style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                              onTap: () => cubit.logout(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

