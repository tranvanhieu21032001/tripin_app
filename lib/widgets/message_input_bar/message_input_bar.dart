import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wemu_team_app/core/configs/assets/app_vector.dart';
import 'package:wemu_team_app/core/configs/theme/app_colors.dart';

class MessageInputBar extends StatelessWidget {
  const MessageInputBar({
    super.key,
    this.controller,
    this.hintText = 'Message',
    this.onAddPressed,
    this.onSendPressed,
  });

  final TextEditingController? controller;
  final String hintText;
  final VoidCallback? onAddPressed;
  final VoidCallback? onSendPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.lightGrey, width: 1),
        ),
      ),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F3F3),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          children: [
            _iconButtonInsidePill(
              svgAsset: AppVector.add,
              onPressed: onAddPressed,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: hintText,
                  hintStyle: const TextStyle(color: AppColors.grey),
                ),
              ),
            ),
            const SizedBox(width: 6),
            _iconButtonInsidePill(
              svgAsset: AppVector.send,
              onPressed: onSendPressed,
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconButtonInsidePill({
    required String svgAsset,
    VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: 34,
      height: 34,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onPressed,
          child: Center(
            child: SvgPicture.asset(
              svgAsset,
              width:24,
              height:24,
              colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}


