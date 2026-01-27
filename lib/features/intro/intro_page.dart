import 'package:flutter/material.dart';
import 'package:wemu_team_app/core/configs/assets/app_images.dart';
import 'package:wemu_team_app/core/configs/theme/app_colors.dart';
import 'package:wemu_team_app/widgets/button/basic_button.dart';
import 'package:wemu_team_app/features/login/login_page.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              AppImages.introBG,
              fit: BoxFit.cover,
            ),
          ),

          // Overlay
          Positioned.fill(
            child: Container(
              color: AppColors.introOverlay,
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),

                  // Logo
                 Align(
                    alignment: Alignment.topLeft,
                    child: Image.asset(AppImages.logo),
                  ),
                  // Title'
                  const SizedBox(height: 6),
                  const Text(
                    'Wemu Team',
                    style: TextStyle(
                      fontSize: 46,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Subtitle
                  const Text(
                    'Everything your team needs to stay\non top of work.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Sign In button
                  BasicButton(
                    title: 'Sign In',
                    height: 50,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const LoginPage()));
                    },
                  ),

                  const SizedBox(height: 115),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
