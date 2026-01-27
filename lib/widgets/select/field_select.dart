import 'package:flutter/material.dart';
import 'package:wemu_team_app/core/configs/theme/app_colors.dart';

class FieldSelectOption {
  final String value;
  final String label;

  const FieldSelectOption({
    required this.value,
    required this.label,
  });
}

class FieldSelect extends StatefulWidget {
  final String label;
  final String? placeholder;
  final List<FieldSelectOption> options;
  final List<String> selectedValues;
  final bool multi;
  final bool isOutLine;
  final Color? labelColor;
  final ValueChanged<List<String>> onChanged;

  const FieldSelect({
    super.key,
    required this.label,
    this.labelColor,
    this.placeholder,
    required this.options,
    required this.selectedValues,
    this.multi = false,
    this.isOutLine = false,
    required this.onChanged,
  });

  @override
  State<FieldSelect> createState() => _FieldSelectState();
}

class _FieldSelectState extends State<FieldSelect> {
  final LayerLink _link = LayerLink();
  final GlobalKey _key = GlobalKey();
  OverlayEntry? _overlay;
  OverlayState? _overlayState;
  double _inputWidth = 0;
  BuildContext? _overlayContext;
  List<String> _overlaySelected = [];

  String _labelForValue(String value) {
    for (final opt in widget.options) {
      if (opt.value == value) return opt.label;
    }
    return value;
  }

  OverlayEntry _createOverlayEntry() {
    _overlaySelected = List<String>.from(widget.selectedValues);

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
                              final item = entry.value;

                              final isSelected = !widget.multi &&
                                  _overlaySelected.isNotEmpty &&
                                  _overlaySelected.first == item.value;

                              final isSelectedMulti = widget.multi && _overlaySelected.contains(item.value);
                              final isLast = index == widget.options.length - 1;

                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (widget.multi) {
                                        if (isSelectedMulti) {
                                          _overlaySelected.remove(item.value);
                                        } else {
                                          _overlaySelected.add(item.value);
                                        }
                                      } else {
                                        _overlaySelected.clear();
                                        _overlaySelected.add(item.value);
                                      }

                                      // Update parent widget
                                      widget.onChanged(List<String>.from(_overlaySelected));

                                      if (!widget.multi) {
                                        _removeDropdown();
                                      } else {
                                        // Rebuild StatefulBuilder to show updated checkmarks
                                        setOverlayState(() {});
                                      }
                                    },
                                    child: Container(
                                      color: (isSelected || isSelectedMulti) ? AppColors.blue.withOpacity(0.1) : Colors.transparent,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 12,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(child: Text(item.label)),
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
    if (widget.selectedValues.isEmpty) {
      return Text(
        widget.placeholder ?? 'Select',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: AppColors.black, fontWeight: FontWeight.w400, fontSize: 16),
      );
    }

    if (!widget.multi) {
      return Text(
        _labelForValue(widget.selectedValues.first),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: AppColors.black),
      );
    }

    if (widget.selectedValues.length <= 3) {
      return Text(
        widget.selectedValues.map(_labelForValue).join(', '),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: AppColors.black),
      );
    }

    final firstThree = widget.selectedValues.take(3).map(_labelForValue).join(', ');
    final remaining = widget.selectedValues.length - 3;
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: const TextStyle(color: AppColors.black),
        children: [
          TextSpan(text: firstThree),
          TextSpan(
            text: ', +$remaining',
            style: TextStyle(
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
                  const Icon(Icons.keyboard_arrow_down),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

