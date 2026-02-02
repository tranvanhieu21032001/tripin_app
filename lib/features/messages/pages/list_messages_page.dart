import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wemu_team_app/core/configs/assets/app_vector.dart';
import 'package:wemu_team_app/core/configs/theme/app_colors.dart';
import 'package:wemu_team_app/features/messages/widgets/message_list_item.dart';

class ListMessagesPage extends StatelessWidget {
  const ListMessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final threads = _mockThreads;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: _buildHeader(),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: threads.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = threads[index];
                  return MessageListItem(data: item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Messages',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(AppVector.search),
        ),
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(AppVector.addMessage),
        ),
        Stack(
          alignment: Alignment.topRight,
          children: [
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(AppVector.user),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Text(
                  '3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

final List<MessageListItemData> _mockThreads = [
  MessageListItemData(
    title: 'Billy Jeans',
    subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed',
    timeLabel: '2 min',
    avatarUrl: 'https://i.pravatar.cc/150?img=1',
    isUnread: true,
    trailingIcon: Icons.wb_sunny_outlined,
  ),
  MessageListItemData(
    title: 'Billy Jeans',
    subtitle: 'Typing...',
    timeLabel: '2 min',
    avatarUrl: 'https://i.pravatar.cc/150?img=2',
    isTyping: true,
  ),
  MessageListItemData(
    title: 'Weekend with the boyzzz',
    subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed',
    timeLabel: '2 days',
    avatarText: '12',
    highlight: true,
    isUnread: true,
  ),
  MessageListItemData(
    title: 'Billy Jeans',
    subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed',
    timeLabel: '2 days',
    avatarUrl: 'https://i.pravatar.cc/150?img=3',
  ),
  MessageListItemData(
    title: 'Billy Jeans',
    subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed',
    timeLabel: '5 days',
    avatarUrl: 'https://i.pravatar.cc/150?img=4',
  ),
  MessageListItemData(
    title: 'Billy Jeans',
    subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed',
    timeLabel: '5 days',
    avatarUrl: 'https://i.pravatar.cc/150?img=5',
  ),
  MessageListItemData(
    title: 'Billy Jeans',
    subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed',
    timeLabel: '5 days',
    avatarUrl: 'https://i.pravatar.cc/150?img=6',
  ),
];
