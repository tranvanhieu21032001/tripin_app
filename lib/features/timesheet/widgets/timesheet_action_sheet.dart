import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wemu_team_app/core/configs/assets/app_vector.dart';
import 'package:wemu_team_app/core/configs/theme/app_colors.dart';
import 'package:wemu_team_app/features/timesheet/widgets/add_time_sheet.dart';

class TimesheetActionSheet extends StatelessWidget {
  const TimesheetActionSheet({
    super.key,
    this.onActionSelected,
    this.parentContext,
    this.dialogContext,
  });

  final ValueChanged<String>? onActionSelected;
  final BuildContext? parentContext;
  final BuildContext? dialogContext;

  /// Show as a centered dialog with dimmed background (like the design).
  static Future<String?> show(BuildContext context) {
    return showDialog<String>(
      context: context,
      barrierColor: AppColors.introOverlay,
      barrierDismissible: true,
      builder: (dialogContext) => Stack(
        children: [
          // Align the sheet near the bottom-right corner.
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 96, right: 32),
              child: TimesheetActionSheet(
                parentContext: context,
                dialogContext: dialogContext,
                onActionSelected: (value) {
                  if (dialogContext.mounted && Navigator.canPop(dialogContext)) {
                    Navigator.of(dialogContext).pop(value);
                  }
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24, right: 52),
              child: Builder(
                builder: (builderContext) => GestureDetector(
                  onTap: () => Navigator.of(builderContext).pop(),
                  child: Transform.scale(
                    scale: 1.1,
                    child: Transform.rotate(
                      angle: math.pi / 4,
                      child: SvgPicture.asset(AppVector.addGreen),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 235,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Builder(
            builder: (builderContext) => _buildItem(
              builderContext,
              label: 'Add Time',
              onTap: () async {
                // Close the action sheet first
                if (dialogContext != null && dialogContext!.mounted && Navigator.canPop(dialogContext!)) {
                  Navigator.of(dialogContext!).pop();
                }
                // Wait a frame to ensure dialog is closed
                await Future.delayed(const Duration(milliseconds: 100));
                // Open Add Time sheet using the original parent context
                if (parentContext != null && parentContext!.mounted) {
                  await AddTimeSheet.show(context: parentContext!);
                }
                onActionSelected?.call('add_time');
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 4, 20, 4),
            child: Divider(height: 1, color: AppColors.lightGrey),
          ),
          _buildItem(
            context,
            label: 'Request Off',
            onTap: () {
              onActionSelected?.call('request_off');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItem(
    BuildContext context, {
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
              color: AppColors.black,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }
}
