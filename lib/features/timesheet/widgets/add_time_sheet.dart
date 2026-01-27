import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wemu_team_app/core/configs/assets/app_vector.dart';
import 'package:wemu_team_app/core/configs/theme/app_colors.dart';
import 'package:wemu_team_app/core/di/injection.dart';
import 'package:wemu_team_app/features/timesheet/presentation/bloc/timesheet_cubit.dart';
import 'package:wemu_team_app/features/timesheet/presentation/bloc/timesheet_state.dart';
import 'package:wemu_team_app/widgets/button/basic_button.dart';
import 'package:wemu_team_app/widgets/datetime/date_time_start_end.dart';
import 'package:wemu_team_app/widgets/select/field_user_select.dart';
import 'package:wemu_team_app/features/login/domain/repositories/auth_repository.dart';

class AddTimeSheet extends StatefulWidget {
  const AddTimeSheet({super.key, this.sheetContext});

  final BuildContext? sheetContext;

  static Future<void> show({required BuildContext context}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.introOverlay,
      builder: (sheetContext) => AddTimeSheet(sheetContext: sheetContext),
    );
  }

  @override
  State<AddTimeSheet> createState() => _AddTimeSheetState();
}

class _BreakTime {
  TimeOfDay? start;
  TimeOfDay? end;

  _BreakTime({this.start, this.end});
}

class _AddTimeSheetState extends State<AddTimeSheet> {
  final TimesheetCubit _timesheetCubit = getIt<TimesheetCubit>();
  final AuthRepository _authRepository = getIt<AuthRepository>();

  List<String> selectedIds = [];

  late DateTime _date;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  final List<_BreakTime> _breaks = [];
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _date = DateTime.now();
    _startTime = const TimeOfDay(hour: 9, minute: 0);
    _endTime = const TimeOfDay(hour: 17, minute: 0);

    final user = _authRepository.getCachedUser();
    if (user != null) {
      selectedIds = [user.id];
    }

    _timesheetCubit.loadMembers(status: 'active');
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickBreakTime(int index, {required bool isStart}) async {
    final current = isStart ? (_breaks[index].start ?? _startTime) : (_breaks[index].end ?? _endTime);

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: current,
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _breaks[index].start = picked;
        } else {
          _breaks[index].end = picked;
        }
      });
    }
  }

  Widget _buildBreakTimeField(
    int index, {
    required bool isStart,
  }) {
    final time = isStart ? _breaks[index].start : _breaks[index].end;

    String label;
    if (time == null) {
      label = 'Select time';
    } else {
      final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
      final minute = time.minute.toString().padLeft(2, '0');
      final period = time.period == DayPeriod.am ? 'AM' : 'PM';
      label = '$hour:$minute $period';
    }

    return GestureDetector(
      onTap: () => _pickBreakTime(index, isStart: isStart),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: AppColors.lightGrey),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: time == null ? AppColors.grey : AppColors.black,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  DateTime _combineDateTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  bool _isSameOrBefore(DateTime a, DateTime b) {
    return a.isAtSameMomentAs(b) || a.isBefore(b);
  }

  String? _validateForm() {
    if (selectedIds.isEmpty) {
      return 'Please select employee';
    }

    final clockIn = _combineDateTime(_date, _startTime);

    final clockOut = _combineDateTime(_date, _endTime);
    if (_isSameOrBefore(clockOut, clockIn)) {
      return 'End time must be after start time';
    }

    if (_breaks.isNotEmpty) {
      final firstBreak = _breaks.first;
      if (firstBreak.start != null || firstBreak.end != null) {
        if (firstBreak.start == null || firstBreak.end == null) {
          return 'Please select break start and break end';
        }
        final breakStart = _combineDateTime(_date, firstBreak.start!);
        final breakEnd = _combineDateTime(_date, firstBreak.end!);
        if (_isSameOrBefore(breakEnd, breakStart)) {
          return 'Break end must be after break start';
        }
      }
    }

    return null;
  }

  Future<void> _onSubmit() async {
    final error = _validateForm();
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    final employeeId = selectedIds.first;
    final clockIn = _combineDateTime(_date, _startTime);
    final clockOut = _combineDateTime(_date, _endTime);

    DateTime? breakStart;
    DateTime? breakEnd;
    if (_breaks.isNotEmpty) {
      final firstBreak = _breaks.first;
      if (firstBreak.start != null && firstBreak.end != null) {
        breakStart = _combineDateTime(_date, firstBreak.start!);
        breakEnd = _combineDateTime(_date, firstBreak.end!);
      }
    }

    await _timesheetCubit.createTimesheetApproved(
      employeeId: employeeId,
      clockInTime: clockIn,
      clockOutTime: clockOut,
      breakStart: breakStart,
      breakEnd: breakEnd,
      notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
    );
  }

  Future<void> _onCreateStatusChanged(TimesheetState state) async {
    if (!mounted) return;

    if (state.createStatus == TimesheetCreateStatus.failure && state.createErrorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.createErrorMessage!)),
      );
      return;
    }

    if (state.createStatus == TimesheetCreateStatus.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Timesheet created successfully')),
      );
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  List<UserOption> _mapEmployeesToOptions(List<Map<String, dynamic>> employees) {
    return employees
        .map((e) {
          final id = (e['_id'] ?? e['id'] ?? '').toString();
          final first = (e['firstName'] ?? '').toString().trim();
          final last = (e['lastName'] ?? '').toString().trim();
          final displayName = (e['displayName'] ?? e['name'] ?? '').toString().trim();
          final email = (e['email'] ?? '').toString().trim();
          final phone = (e['phone'] ?? '').toString().trim();
          final avatar = (e['avatar'] ?? e['photo'] ?? '').toString().trim();

          var name = displayName.isNotEmpty ? displayName : ('$first $last').trim();
          if (name.isEmpty) {
            name = email.isNotEmpty ? email : (phone.isNotEmpty ? phone : 'Unknown');
          }

          return UserOption(
            id: id,
            name: name,
            avatarUrl: avatar.isNotEmpty ? avatar : null,
          );
        })
        .where((o) => o.id.isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TimesheetCubit, TimesheetState>(
      bloc: _timesheetCubit,
      listenWhen: (prev, curr) => prev.createStatus != curr.createStatus,
      listener: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _onCreateStatusChanged(state);
        });
      },
      buildWhen: (prev, curr) =>
          prev.membersStatus != curr.membersStatus ||
          prev.members.length != curr.members.length ||
          prev.createStatus != curr.createStatus,
      builder: (context, state) {
        final currentUser = _authRepository.getCachedUser();
        var options = _mapEmployeesToOptions(state.members);
        
        if (currentUser != null) {
          final currentUserOption = UserOption(
            id: currentUser.id,
            name: currentUser.displayNameOrGuest,
            avatarUrl: currentUser.avatar.isNotEmpty ? currentUser.avatar : null,
          );
          
          if (!options.any((o) => o.id == currentUser.id)) {
            options = [currentUserOption, ...options];
          }
        }
        
        final isSubmitting = state.createStatus == TimesheetCreateStatus.loading;

        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.90,
          minChildSize: 0.25,
          maxChildSize: 0.95,
          builder: (sheetContext, scrollController) {
            return Material(
              color: Colors.transparent,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Add Time',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    if (widget.sheetContext != null && Navigator.canPop(widget.sheetContext!)) {
                                      Navigator.pop(widget.sheetContext!);
                                    }
                                  },
                                  icon: const Icon(Icons.close),
                                ),
                              ],
                            ),
                           const Divider(height: 1, color: AppColors.lightGrey),
                            const SizedBox(height: 16),
                            FieldUserSelect(
                              label: 'Assign',
                              isOutLine: true,
                              showDropdownIcon: true,
                              labelColor: AppColors.grey,
                              placeholder: state.membersStatus == TimesheetMembersStatus.loading
                                  ? 'Loading employees...'
                                  : options.isEmpty
                                      ? 'No employees found'
                                      : 'Please select employee',
                              options: options,
                              selectedIds: selectedIds,
                              multi: false,
                              onChanged: (newSelectedIds) {
                                setState(() {
                                  selectedIds = newSelectedIds;
                                });
                              },
                            ),
                            const SizedBox(height: 24),
                            DateTimeStartEnd(
                              showIcons: false,
                              isOutLine: true,
                              date: _date,
                              startTime: _startTime,
                              endTime: _endTime,
                              minDate: _date,
                              onDateChanged: (newDate) {
                                setState(() {
                                  _date = newDate;
                                });
                              },
                              onStartTimeChanged: (newTime) {
                                setState(() {
                                  _startTime = newTime;
                                });
                              },
                              onEndTimeChanged: (newTime) {
                                setState(() {
                                  _endTime = newTime;
                                });
                              },
                            ),
                            if (_breaks.isEmpty) ...[
                              const SizedBox(height: 16),
                              OutlinedButton.icon(
                                onPressed: () {
                                  if (_breaks.isEmpty) {
                                    setState(() {
                                      _breaks.add(_BreakTime());
                                    });
                                  }
                                },
                                icon: const Icon(Icons.add, color: AppColors.black),
                                label: const Text(
                                  'Add break',
                                  style: TextStyle(color: AppColors.black),
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  side: const BorderSide(color: AppColors.lightGrey),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                              ),
                            ],
                            ...List.generate(_breaks.length, (index) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Break start',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.grey,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Break end',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.grey,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(child: SizedBox()),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildBreakTimeField(
                                            index,
                                            isStart: true,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: _buildBreakTimeField(
                                            index,
                                            isStart: false,
                                          ),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _breaks.removeAt(index);
                                                });
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(8),
                                                child: SvgPicture.asset(
                                                  AppVector.trashRed,
                                                  width: 28,
                                                  height: 28,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                            const SizedBox(height: 24),
                            const Text(
                              'Notes',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.lightGrey),
                              ),
                              child: TextField(
                                controller: _notesController,
                                maxLines: null,
                                expands: true,
                                decoration: const InputDecoration(
                                  hintText: '',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.fromLTRB(14, 14, 14, 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: BasicButton(
                        title: isSubmitting ? 'Adding...' : 'Add & Approve',
                        height: 50,
                        onPressed: isSubmitting ? () {} : _onSubmit,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
