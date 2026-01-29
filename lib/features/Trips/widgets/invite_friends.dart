import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wemu_team_app/core/configs/assets/app_vector.dart';
import 'package:wemu_team_app/core/configs/theme/app_colors.dart';
import 'package:wemu_team_app/widgets/button/basic_button.dart';
import 'package:wemu_team_app/widgets/user_profile/user_profile.dart';

class InviteFriends extends StatefulWidget {
  const InviteFriends({super.key});

  @override
  State<InviteFriends> createState() => _InviteFriendsState();
}

class _InviteFriendsState extends State<InviteFriends> {
  // Temporary data for UI. Later this can be fed from API / contacts.
  final List<_FriendItem> _friends = List.generate(
    10,
    (i) => _FriendItem(
      name: 'Billy Jeans',
      avatarUrl: 'https://i.pravatar.cc/150?img=${(i % 70) + 1}',
      selected: i % 2 == 0,
    ),
  );

  int get _selectedCount => _friends.where((f) => f.selected).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Transform.scale(
            scale: 0.9,
            child: SvgPicture.asset(AppVector.back),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Invite friends',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                itemCount: _friends.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final friend = _friends[index];
                  return _friendRow(
                    friend: friend,
                    onTap: () {
                      setState(() => _friends[index] = friend.copyWith(
                            selected: !friend.selected,
                          ));
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: BasicButton(
                  onPressed: _selectedCount == 0 ? () {} : () {},
                  title: 'Send invite',
                  backgroundColor: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _friendRow({
    required _FriendItem friend,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Expanded(
                child: UserProfile(
                  name: friend.name,
                  radius: 28,
                  backgroundUrl: friend.avatarUrl,
                  padding: EdgeInsets.zero,
                ),
              ),
              _selectionDot(selected: friend.selected),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectionDot({required bool selected}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      width: 15,
      height: 15,
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : const Color(0xFFD9D9D9),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _FriendItem {
  const _FriendItem({
    required this.name,
    required this.avatarUrl,
    required this.selected,
  });

  final String name;
  final String avatarUrl;
  final bool selected;

  _FriendItem copyWith({
    String? name,
    String? avatarUrl,
    bool? selected,
  }) {
    return _FriendItem(
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      selected: selected ?? this.selected,
    );
  }
}


