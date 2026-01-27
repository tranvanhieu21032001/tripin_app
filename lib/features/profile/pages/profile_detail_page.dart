import 'package:flutter/material.dart';
import 'package:wemu_team_app/core/configs/theme/app_colors.dart';
import 'package:wemu_team_app/core/di/injection.dart';
import 'package:wemu_team_app/features/profile/data/models/profile.dart';
import 'package:wemu_team_app/features/profile/domain/usecases/get_profile_usecase.dart';

class ProfileDetailPage extends StatelessWidget {
  const ProfileDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget item(String label, String value) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: AppColors.grey)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 16, color: AppColors.black)),
          ],
        ),
      );
    }

    Widget buildBody(Profile profile) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            const Text(
              'Profile',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 18),
            item('First Name', profile.firstName),
            item('Last Name', profile.lastName),
            item('E-mail', profile.email),
            item('Mobile', profile.mobile),
            item('Birthday', profile.birthdayLabel),
            item('Gender', profile.gender),
            item('Address', profile.address),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: FutureBuilder<Profile>(
          future: getIt<GetProfileUseCase>()(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Failed to load profile',
                  style: TextStyle(color: AppColors.grey),
                ),
              );
            }
            final profile = snapshot.data;
            if (profile == null) {
              return const Center(
                child: Text(
                  'No profile data',
                  style: TextStyle(color: AppColors.grey),
                ),
              );
            }
            return buildBody(profile);
          },
        ),
      ),
    );
  }
}
