import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wemu_team_app/core/configs/assets/app_images.dart';
import 'package:wemu_team_app/core/configs/assets/app_vector.dart';
import 'package:wemu_team_app/core/configs/theme/app_colors.dart';
import 'package:wemu_team_app/features/login/login_page.dart';
import 'package:wemu_team_app/widgets/button/basic_button.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(child: Image.asset(AppImages.introBG, fit: BoxFit.cover)),

          // Overlay
          Positioned.fill(child: Container(color: AppColors.introOverlay)),

          // Avatar pins scattered around the map (above overlay)
          // Top-left
          Positioned(
            left: size.width * -0.03,
            top: size.height * 0.03,
            child: _buildAvatarPin(AppImages.avata1, avatarSize: 40),
          ),
          // Mid-left
          Positioned(
            left: size.width * -0.02,
            top: size.height * 0.4,
            child: _buildAvatarPin(AppImages.avata2, avatarSize: 60),
          ),
          // Bottom-left
          Positioned(
            left: size.width * 0.12,
            top: size.height * 0.55,
            child: _buildAvatarPin(AppImages.avata3, avatarSize: 45),
          ),
          // Top-right
          Positioned(
            right: size.width * 0.1,
            top: size.height * 0.05,
            child: _buildAvatarPin(AppImages.avata4, avatarSize: 50),
          ),
          // Mid-right
          Positioned(
            right: size.width * 0.5,
            top: size.height * 0.45,
            child: _buildAvatarPin(AppImages.avata5, avatarSize: 30),
          ),
          // Bottom-right
          Positioned(
            right: size.width * -0.03,
            top: size.height * 0.5,
            child: _buildAvatarPin(AppImages.avata6, avatarSize: 60),
          ),
          // Center-top
          Positioned(
            left: size.width * 0.5 - 29,
            top: size.height * 0.1,
            child: _buildAvatarPin(AppImages.avata7, avatarSize: 52),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  const Spacer(flex: 3),

                  // Logo "TRIPin"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'TRIP',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary, // Teal color
                        ),
                      ),
                      const Text(
                        'in',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  // Tagline
                  const Text(
                    'Lorem ipsum dolor sit...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),

                  const Spacer(flex: 3),

                  // Sign with Apple button
                  BasicButton(
                    title: 'Sign with Apple',
                    height: 45,
                    iconWidget: SvgPicture.asset(
                      AppVector.apple,
                      width: 24,
                      height: 24,
                    ),
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    borderRadius: 40,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  // Sign with Google button
                  BasicButton(
                    title: 'Sign with Google',
                    height: 45,
                    iconWidget: SvgPicture.asset(
                      AppVector.google,
                      width: 24,
                      height: 24,
                    ),
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    borderRadius: 40,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // Sign in with email text
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                    child: const Text(
                      'Sign in with your E-mail',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarPin(String imagePath, {double avatarSize = 60}) {
    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(child: Image.asset(imagePath, fit: BoxFit.cover)),
    );
  }
}
