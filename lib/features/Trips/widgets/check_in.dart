import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wemu_team_app/core/configs/assets/app_images.dart';
import 'package:wemu_team_app/core/configs/assets/app_vector.dart';
import 'package:wemu_team_app/core/configs/theme/app_colors.dart';
import 'package:wemu_team_app/features/messages/widgets/message_chat_sheet.dart';
import 'package:wemu_team_app/widgets/button/basic_button.dart';
import 'package:wemu_team_app/widgets/user_profile/user_profile.dart';

class CheckInPage extends StatefulWidget {
  const CheckInPage({super.key});

  @override
  State<CheckInPage> createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  bool _showChatSheet = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background map image
          Positioned.fill(
            child: Image.asset(AppImages.introBG, fit: BoxFit.cover),
          ),
          Positioned.fill(child: Container(color: AppColors.introOverlay)),

          // Header on top of map
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
              child: Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: SvgPicture.asset(
                      AppVector.back,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Weekend with the boyzzz',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      AppVector.more,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Draggable bottom sheet content
          DraggableScrollableSheet(
            initialChildSize: 0.55,
            minChildSize: 0.45,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              if (_showChatSheet) {
                return MessageChatSheet(scrollController: scrollController);
              } else {
                return _buildCheckInSheet(context, scrollController);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCheckInSheet(BuildContext context, ScrollController scrollController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Background image fills entire bottom sheet
            Positioned.fill(
              child: Image.asset(AppImages.exam, fit: BoxFit.cover),
            ),
            // Dark gradient to make text readable
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),
            // Content scrolling on top of image
            SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Close circle
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {},
                        icon: SvgPicture.asset(
                          AppVector.close,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Avatars stack
                      SizedBox(
                        width: 56,
                        height: 32,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: const [
                            // avatar phía sau (bên trái)
                            Positioned(
                              left: 0,
                              child: UserProfile(
                                name: null,
                                radius: 16,
                                backgroundUrl: 'https://i.pravatar.cc/150?img=5',
                                padding: EdgeInsets.zero,
                              ),
                            ),
                            // avatar phía trước lệch sang phải một chút
                            Positioned(
                              left: 18,
                              child: UserProfile(
                                name: null,
                                radius: 16,
                                backgroundUrl: 'https://i.pravatar.cc/150?img=6',
                                padding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 120),
                  const Text(
                    'BAR',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Pig and Whistle',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '1 Fortitude Valley, QLD, 2006',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                      ),
                    ),
                    child: const Text(
                      'Today @ 5:30 PM',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: BasicButton(
                      onPressed: () {
                        setState(() {
                          _showChatSheet = true;
                        });
                      },
                      title: 'Check in',
                      backgroundColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
