import 'package:flutter/material.dart';
import 'package:wemu_team_app/core/configs/theme/app_colors.dart';
import 'package:wemu_team_app/features/messages/pages/message_chat_page.dart';
import 'package:wemu_team_app/widgets/user_profile/user_profile.dart';

class MessageListItemData {
  const MessageListItemData({
    required this.title,
    required this.subtitle,
    required this.timeLabel,
    this.avatarUrl,
    this.avatarText,
    this.isUnread = false,
    this.isTyping = false,
    this.highlight = false,
    this.trailingIcon,
  });

  final String title;
  final String subtitle;
  final String timeLabel;
  final String? avatarUrl;
  final String? avatarText;
  final bool isUnread;
  final bool isTyping;
  final bool highlight;
  final IconData? trailingIcon;
}

class MessageListItem extends StatelessWidget {
  const MessageListItem({
    super.key,
    required this.data,
  });

  final MessageListItemData data;

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
      fontSize: 16,
      fontWeight: data.highlight ? FontWeight.w700 : FontWeight.w600,
      color: AppColors.black,
    );

    final subtitleStyle = TextStyle(
      fontSize: 13,
      fontStyle: data.isTyping ? FontStyle.italic : FontStyle.normal,
      color: data.isTyping ? AppColors.primary : AppColors.grey,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => MessageChatPage(thread: data),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              UserProfile(
                name: null,
                radius: 28,
                avatarText: data.avatarText,
                backgroundUrl: data.avatarUrl,
                padding: EdgeInsets.zero,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.title,
                        style: titleStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text(
                      data.subtitle,
                      style: subtitleStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (data.trailingIcon != null)
                        Icon(
                          data.trailingIcon,
                          size: 16,
                          color: AppColors.amber,
                        ),
                      if (data.trailingIcon != null) const SizedBox(width: 4),
                      Text(
                        data.timeLabel,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  if (data.isUnread)
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


