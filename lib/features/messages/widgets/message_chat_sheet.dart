import 'package:flutter/material.dart';
import 'package:wemu_team_app/core/configs/theme/app_colors.dart';
import 'package:wemu_team_app/widgets/calendar_bottom_sheet/calendar_bottom_sheet.dart';
import 'package:wemu_team_app/widgets/message_input_bar/message_input_bar.dart';
import 'package:wemu_team_app/widgets/user_profile/user_profile.dart';

class MessageChatSheet extends StatelessWidget {
  const MessageChatSheet({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              // Date pill at top
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const CalendarBottomSheet(),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.lightGrey),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.calendar_today, size: 14, color: AppColors.black),
                          SizedBox(width: 6),
                          Text(
                            'Today, 17th',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Chat messages
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  children: [
                    _buildChatMessage(
                      avatarUrl: 'https://i.pravatar.cc/150?img=3',
                      message: "I'm excited to see you guys. It's been a long time.",
                    ),
                    const SizedBox(height: 12),
                    _buildChatMessage(
                      avatarUrl: 'https://i.pravatar.cc/150?img=4',
                      message: 'Thank You.',
                    ),
                    const SizedBox(height: 12),
                    _buildChatMessage(
                      avatarUrl: 'https://i.pravatar.cc/150?img=7',
                      message: 'Is it okay if I invite people from work?',
                    ),
                  ],
                ),
              ),
              // Message input bar
              const MessageInputBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatMessage({
    required String avatarUrl,
    required String message,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserProfile(
          name: null,
          radius: 28,
          backgroundUrl: avatarUrl,
          padding: EdgeInsets.zero,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

