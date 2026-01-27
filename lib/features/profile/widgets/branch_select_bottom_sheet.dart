import 'package:flutter/material.dart';
import 'package:wemu_team_app/core/configs/theme/app_colors.dart';
import 'package:wemu_team_app/models/branch.dart';

class BranchSelectBottomSheet extends StatelessWidget {
  final List<Branch> branches;
  final String? selectedBranchId;
  final ValueChanged<Branch> onSelected;

  const BranchSelectBottomSheet({
    super.key,
    required this.branches,
    required this.selectedBranchId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Select Branch',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: branches.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final branch = branches[index];
                final selected = branch.id == selectedBranchId;
                return ListTile(
                  title: Text(branch.name),
                  trailing: selected
                      ? const Icon(Icons.check, color: AppColors.blue)
                      : null,
                  onTap: () {
                    Navigator.of(context).pop();
                    onSelected(branch);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


