import 'package:flutter/material.dart';
import 'package:wemu_team_app/core/configs/theme/app_colors.dart';
import 'package:wemu_team_app/core/configs/assets/app_images.dart';

class UserOption {
  final String id;
  final String name;
  final String? avatarUrl;

  const UserOption({
    required this.id,
    required this.name,
    this.avatarUrl,
  });
}

class FieldUserSelect extends StatefulWidget {
  final String label;
  final String? placeholder;
  final List<UserOption> options;
  final List<String> selectedIds;
  final bool multi;
  final bool isOutLine;
  final bool showDropdownIcon;
  final Color? labelColor;
  final ValueChanged<List<String>> onChanged;

  const FieldUserSelect({
    super.key,
    required this.label,
    this.labelColor,
    this.placeholder,
    required this.options,
    required this.selectedIds,
    this.multi = false,
    this.isOutLine = false,
    this.showDropdownIcon = false,
    required this.onChanged,
  });

  @override
  State<FieldUserSelect> createState() => _FieldUserSelectState();
}

class _FieldUserSelectState extends State<FieldUserSelect> {
  final LayerLink _link = LayerLink();
  final GlobalKey _key = GlobalKey();
  OverlayEntry? _overlay;
  OverlayState? _overlayState;
  double _inputWidth = 0;
  BuildContext? _overlayContext;
  List<String> _overlaySelected = [];

  UserOption? _getUserById(String id) {
    try {
      return widget.options.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  OverlayEntry _createOverlayEntry() {
    _overlaySelected = List<String>.from(widget.selectedIds);
    
    return OverlayEntry(
      builder: (overlayContext) {
        _overlayContext = overlayContext;
        return Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _removeDropdown,
            child: Stack(
              children: [
                CompositedTransformFollower(
                  link: _link,
                  offset: const Offset(0, 56),
                  child: Material(
                    elevation: 6,
                    borderRadius: BorderRadius.circular(10),
                    child: StatefulBuilder(
                      builder: (context, setOverlayState) {
                        return Container(
                          width: _inputWidth,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.lightGrey),
                          ),
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.4,
                          ),
                          child: ListView(
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: widget.options.asMap().entries.map((entry) {
                              final index = entry.key;
                              final user = entry.value;
                              final isSelected = _overlaySelected.contains(user.id);
                              final isLast = index == widget.options.length - 1;

                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (widget.multi) {
                                        if (isSelected) {
                                          _overlaySelected.remove(user.id);
                                        } else {
                                          _overlaySelected.add(user.id);
                                        }
                                      } else {
                                        _overlaySelected.clear();
                                        _overlaySelected.add(user.id);
                                      }
                                      
                                      // Update parent widget
                                      widget.onChanged(List<String>.from(_overlaySelected));

                                      if (!widget.multi) {
                                        _removeDropdown();
                                      } else {
                                        // Rebuild StatefulBuilder to show updated background
                                        setOverlayState(() {});
                                      }
                                    },
                                    child: Container(
                                      color: isSelected ? AppColors.blue.withOpacity(0.1) : Colors.transparent,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 12,
                                      ),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 18,
                                            backgroundImage: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                                                ? NetworkImage(user.avatarUrl!)
                                                : const AssetImage(AppImages.avatar) as ImageProvider,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              user.name,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (!isLast)
                                    Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: AppColors.lightGrey,
                                    ),
                                ],
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _toggleDropdown(BuildContext context) {
    if (_overlay != null) {
      _removeDropdown();
      return;
    }

    final box = _key.currentContext?.findRenderObject() as RenderBox?;
    _inputWidth = box?.size.width ?? 200;

    final overlay = Overlay.of(context);
    if (overlay == null) return;

    _overlayState = overlay;
    _overlay = _createOverlayEntry();
    overlay.insert(_overlay!);
  }

  void _removeDropdown() {
    _overlay?.remove();
    _overlay = null;
    _overlayState = null;
    _overlayContext = null;
  }

  Widget _buildSelectedText() {
    if (widget.selectedIds.isEmpty) {
      return Text(
        widget.placeholder ?? 'Select',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: AppColors.black,
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
      );
    }

    if (!widget.multi) {
      final user = _getUserById(widget.selectedIds.first);
      if (user == null) return const SizedBox();

      // Single select: show avatar + name in the input
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundImage: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                ? NetworkImage(user.avatarUrl!)
                : const AssetImage(AppImages.avatar) as ImageProvider,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              user.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      );
    }

    final selectedUsers = widget.selectedIds
        .map((id) => _getUserById(id))
        .where((user) => user != null)
        .map((user) => user!.name)
        .toList();

    if (selectedUsers.length <= 3) {
      return Text(
        selectedUsers.join(', '),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: AppColors.black),
      );
    }

    final firstThree = selectedUsers.take(3).join(', ');
    final remaining = selectedUsers.length - 3;
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: const TextStyle(color: AppColors.black),
        children: [
          TextSpan(text: firstThree),
          TextSpan(
            text: ', +$remaining',
            style: const TextStyle(
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _removeDropdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: widget.labelColor ?? AppColors.black,
          ),
        ),
        const SizedBox(height: 5),
        CompositedTransformTarget(
          link: _link,
          child: GestureDetector(
            onTap: () => _toggleDropdown(context),
            child: Container(
              key: _key,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: widget.isOutLine
                  ? BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(color: AppColors.lightGrey),
                      ),
                    )
                  : BoxDecoration(
                      color: const Color(0xFFF3F3F3),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.lightGrey),
                    ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildSelectedText(),
                  ),
                  if (widget.showDropdownIcon)
                    const Icon(Icons.keyboard_arrow_down, color: AppColors.grey),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

