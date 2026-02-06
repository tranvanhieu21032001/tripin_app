import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wemu_team_app/core/configs/assets/app_images.dart';
import 'package:wemu_team_app/core/configs/assets/app_vector.dart';
import 'package:wemu_team_app/core/configs/theme/app_colors.dart';
import 'package:wemu_team_app/widgets/button/basic_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _showMoreBottomSheet(BuildContext context) {
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildActionItem(context, title: 'Remove', onTap: () {}),
              const SizedBox(height: 12),
              _buildActionItem(context, title: 'Block', onTap: () {}),
              const SizedBox(height: 12),
              _buildActionItem(context, title: 'Report', onTap: () {}),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionItem(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: () {
        Navigator.of(context).pop();
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header
              Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: SvgPicture.asset(AppVector.back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Spacer(),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: SvgPicture.asset(AppVector.more),
                    onPressed: () => _showMoreBottomSheet(context),
                  ),
                ],
              ),
              // Profile Info
              const CircleAvatar(radius: 35, backgroundImage: AssetImage(AppImages.avata1)),
              const SizedBox(height: 8),
              const Text(
                'Billy Jeans',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black),
              ),
              const SizedBox(height: 8),
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    child: BasicButton(
                      onPressed: () {},
                      title: 'ADD',
                      height: 40,
                      backgroundColor: AppColors.black,
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        shape: const CircleBorder(),
                        side: const BorderSide(color: AppColors.black, width: 1.5),
                        padding: const EdgeInsets.all(8),
                      ),
                      child: SvgPicture.asset(
                        AppVector.send,
                        colorFilter: const ColorFilter.mode(AppColors.black, BlendMode.srcIn),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Chip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_on, size: 14, color: AppColors.white),
                    const SizedBox(width: 6),
                    const Text(
                      '16',
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Bio Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'BIO',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.restaurant,
                            size: 72,
                            color: AppColors.black.withOpacity(0.25),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'This person needs to get\nout more.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Posts List
              ..._mockPosts.map((post) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                  child: _PostCard(post: post),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post});

  final PostData post;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: (MediaQuery.of(context).size.width - 48) * 9 / 16,
            width: double.infinity,
            child: Image.asset(post.imageAsset, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          post.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black),
        ),
        const SizedBox(height: 4),
        Text(post.timeAgo, style: TextStyle(fontSize: 14, color: AppColors.black.withOpacity(0.5))),
      ],
    );
  }
}

class PostData {
  const PostData({required this.title, required this.timeAgo, required this.imageAsset});

  final String title;
  final String timeAgo;
  final String imageAsset;
}

final List<PostData> _mockPosts = [
  PostData(title: 'Pig & Whistle', timeAgo: '2 days ago', imageAsset: AppImages.exam),
  PostData(title: 'Noosa', timeAgo: '23 days ago', imageAsset: AppImages.exam1),
];
