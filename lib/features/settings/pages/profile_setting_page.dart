import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wemu_team_app/core/configs/assets/app_vector.dart';
import 'package:wemu_team_app/core/configs/theme/app_colors.dart';
import 'package:wemu_team_app/widgets/input/field_input.dart';

class ProfileSettingPage extends StatelessWidget {
  const ProfileSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // controllers chỉ để hiển thị giá trị mẫu
    final nameController = TextEditingController(text: 'Billy Jeans');
    final emailController =
        TextEditingController(text: 'billyjeans@gmail.com');
    final mobileController = TextEditingController(text: '+612323232222');
    final bioController =
        TextEditingController(text: 'asdfasfasdfasdf werwerwerwer...');

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: SvgPicture.asset(AppVector.back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Spacer(),
                  const Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: SvgPicture.asset(AppVector.update),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Avatar + change text
            const CircleAvatar(
              radius: 48,
              backgroundImage:
                  NetworkImage('https://i.pravatar.cc/200?img=8'),
            ),
            const SizedBox(height: 10),
            const Text(
              'Change profile pic',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 28),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FieldInput(
                      label: 'FULL NAME',
                      controller: nameController,
                    ),
                    const SizedBox(height: 18),
                    FieldInput(
                      label: 'E-MAIL',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 18),
                    FieldInput(
                      label: 'MOBILE',
                      controller: mobileController,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 18),
                    FieldInput(
                      label: 'BIO',
                      controller: bioController,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
