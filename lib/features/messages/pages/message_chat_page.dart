import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wemu_team_app/core/configs/assets/app_vector.dart';
import 'package:wemu_team_app/core/configs/theme/app_colors.dart';
import 'package:wemu_team_app/features/messages/widgets/message_list_item.dart';
import 'package:wemu_team_app/widgets/message_input_bar/message_input_bar.dart';
import 'package:wemu_team_app/widgets/user_profile/user_profile.dart';

class MessageChatPage extends StatelessWidget {
  const MessageChatPage({super.key, required this.thread});

  final MessageListItemData thread;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  _buildChatBubble(
                    message: "I'm excited to see you guys. It's been a long time.",
                    isMe: false,
                  ),
                  const SizedBox(height: 10),
                  _buildChatBubble(
                    message: 'Is it okay if I invite people from work?',
                    isMe: false,
                  ),
                  const SizedBox(height: 10),
                  _buildChatBubble(
                    message:
                        'Lorem ipsum dolor sit amet, consectetur sadipscing elitr, sed',
                    isMe: true,
                  ),
                ],
              ),
            ),
            const MessageInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Row(
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: SvgPicture.asset(AppVector.back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 6),
          UserProfile(
            name: null,
            radius: 20,
            backgroundUrl: thread.avatarUrl,
            padding: EdgeInsets.zero,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  thread.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.coffee, size: 12, color: AppColors.grey),
                    SizedBox(width: 6),
                    Text(
                      'Typing...',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.more_horiz, color: AppColors.black),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble({
    required String message,
    required bool isMe,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxBubbleWidth = constraints.maxWidth * 0.74;
        Widget bubble;

        if (isMe) {
          // Right-aligned message without background (just text)
          bubble = ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxBubbleWidth),
            child: Text(
              message,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.black,
              ),
            ),
          );
        } else {
          // Left-aligned bubble with light background
          bubble = ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxBubbleWidth),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F3F3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.black,
                ),
              ),
            ),
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [bubble],
        );
      },
    );
  }
}


