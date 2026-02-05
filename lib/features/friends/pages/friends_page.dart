import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wemu_team_app/core/configs/assets/app_images.dart';
import 'package:wemu_team_app/core/configs/assets/app_vector.dart';
import 'package:wemu_team_app/core/configs/theme/app_colors.dart';
import 'package:wemu_team_app/widgets/checkbox/circle_check.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  int _selectedSortIndex = 2; // 0: Latest, 1: Oldest, 2: A-Z

  String get _currentSortLabel {
    switch (_selectedSortIndex) {
      case 0:
        return 'Latest First';
      case 1:
        return 'Oldest First';
      default:
        return 'A - Z Sorting';
    }
  }

  @override
  Widget build(BuildContext context) {
    final friends = _mockFriends;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 12, 16, 4),
              child: _buildHeader(context),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildSortingRow(context),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: friends.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final friend = friends[index];
                  return _FriendListItem(data: friend);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: SvgPicture.asset(AppVector.back),
        ),
        const Expanded(
          child: Center(
            child: Text(
              'Friends',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(AppVector.search),
        ),
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(AppVector.addFriends),
        ),
      ],
    );
  }

  Widget _buildSortingRow(BuildContext context) {
    return InkWell(
      onTap: () => _showSortBottomSheet(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _currentSortLabel,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.arrow_drop_down,
            size: 24,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          child: SizedBox(
            height: 220,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSortOption(context, 0, 'Latest First'),
                const SizedBox(height: 22),
                _buildSortOption(context, 1, 'Oldest First'),
                const SizedBox(height: 22),
                _buildSortOption(context, 2, 'A - Z Sorting'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSortOption(BuildContext context, int index, String label) {
    final bool isSelected = _selectedSortIndex == index;
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: () {
        setState(() => _selectedSortIndex = index);
        Navigator.of(context).pop();
      },
      child: Row(
        children: [
          CircleCheck(done: isSelected),
          const SizedBox(width: 16),
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class FriendListItemData {
  const FriendListItemData({
    required this.name,
    required this.avatarAsset,
  });

  final String name;
  final String avatarAsset;
}

class _FriendListItem extends StatelessWidget {
  const _FriendListItem({required this.data});

  final FriendListItemData data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundImage: AssetImage(data.avatarAsset),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            data.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(
            AppVector.send,
          ),
        ),
      ],
    );
  }
}

final List<FriendListItemData> _mockFriends = [
  FriendListItemData(name: 'Billy Jeans', avatarAsset: AppImages.avata1),
  FriendListItemData(name: 'Billy Jeans', avatarAsset: AppImages.avata2),
  FriendListItemData(name: 'Billy Jeans', avatarAsset: AppImages.avata3),
  FriendListItemData(name: 'Billy Jeans', avatarAsset: AppImages.avata4),
  FriendListItemData(name: 'Billy Jeans', avatarAsset: AppImages.avata5),
  FriendListItemData(name: 'Billy Jeans', avatarAsset: AppImages.avata6),
  FriendListItemData(name: 'Billy Jeans', avatarAsset: AppImages.avata7),
];


