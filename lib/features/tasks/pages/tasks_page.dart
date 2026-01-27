import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:wemu_team_app/core/configs/assets/app_vector.dart';
import 'package:wemu_team_app/core/configs/theme/app_colors.dart';
import 'package:wemu_team_app/core/di/injection.dart';
import 'package:wemu_team_app/features/tasks/data/models/task_item.dart';
import 'package:wemu_team_app/features/tasks/presentation/bloc/tasks_cubit.dart';
import 'package:wemu_team_app/features/tasks/presentation/bloc/tasks_state.dart';
import 'package:wemu_team_app/features/tasks/widgets/task_detail_sheet.dart';
import 'package:wemu_team_app/features/tasks/widgets/task_date_picker.dart';
import 'package:wemu_team_app/features/tasks/widgets/task_title.dart';
import 'package:wemu_team_app/widgets/checkbox/circle_check.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  DateTime? _selectedDate;
  bool _showAll = true;
  late final TasksCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<TasksCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.loadTasks();
    });
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _formatHeaderDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatDayHeader(DateTime date) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final wd = weekdays[date.weekday - 1];
    final mo = months[date.month - 1];
    return '$wd ${date.day}, $mo';
  }

  List<TaskItem> _sortedByDateThenTime(List<TaskItem> tasks) {
    final copy = [...tasks];
    copy.sort((a, b) {
      final aDate = _taskDate(a);
      final bDate = _taskDate(b);
      final da = DateTime(aDate.year, aDate.month, aDate.day);
      final db = DateTime(bDate.year, bDate.month, bDate.day);
      return da.compareTo(db);
    });
    return copy;
  }

  DateTime _taskDate(TaskItem task) => task.startAt ?? DateTime.now();

  int _checkedCountForTask(TaskItem task) {
    if (task.subTasks.isEmpty) return task.isCompleted ? 1 : 0;

    if (!task.isServiceTask) {
      if (task.subTasks.length <= 1) return 0;
      return task.subTasks.skip(1).where((s) => s.isDone).length;
    }

    return task.subTasks.where((s) => s.isDone).length;
  }

  int _totalCountForTask(TaskItem task) {
    if (task.subTasks.isEmpty) return 1;

    if (!task.isServiceTask) {
      return task.subTasks.length <= 1 ? 0 : task.subTasks.length - 1;
    }

    return task.subTasks.length;
  }

  void _openTaskDetail(TaskItem task) {
    TaskDetailSheet.show(
      context: context,
      cubit: _cubit,
      taskId: task.id,
    );
  }

  String _taskTime(TaskItem task) {
    final startAt = task.startAt ?? DateTime.now();
    final endAt = task.endAt;
    final timeFormat = DateFormat('h:mm a');
    if (endAt == null) {
      return timeFormat.format(startAt);
    }
    return '${timeFormat.format(startAt)} - ${timeFormat.format(endAt)}';
  }

  String _taskDue(TaskItem task) {
    final startAt = task.startAt ?? DateTime.now();
    final endAt = task.endAt;
    final dueFormat = DateFormat('MMM d, yyyy');
    final timeFormat = DateFormat('h:mm a');
    if (endAt == null) {
      return '${dueFormat.format(startAt)}, ${timeFormat.format(startAt)}';
    }
    return '${timeFormat.format(startAt)}, ${timeFormat.format(startAt)} - ${timeFormat.format(endAt)}';
  }

  String _taskStatus(TaskItem task) {
    if (task.status.isNotEmpty) {
      return task.status;
    }
    return task.confirmationStatus;
  }

  Widget _taskRow({required TaskItem task}) {
    final int subTaskStartIndex = task.isServiceTask ? 0 : 1;
    final hasSubtasksToRender = task.subTasks.length > subTaskStartIndex;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleCheck(
                done: task.isCompleted,
                onTap: () {
                  final next = !task.isCompleted;
                  _cubit.toggleTaskComplete(task: task, isChecked: next);
                },
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TaskTitle(
                      title: task.displayTitle,
                      done: task.isCompleted,
                      checked: task.subTasks.isNotEmpty ? _checkedCountForTask(task) : null,
                      total: task.subTasks.isNotEmpty ? _totalCountForTask(task) : null,
                      onTap: () => _openTaskDetail(task),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _taskTime(task),
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (hasSubtasksToRender) ...[
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 36),
              child: Column(
                children: List.generate(task.subTasks.length - subTaskStartIndex, (idx) {
                  final i = idx + subTaskStartIndex;
                  final sub = task.subTasks[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleCheck(
                          done: sub.isDone,
                          onTap: () {
                            final next = !sub.isDone;
                            _cubit.toggleSubTask(task: task, subTaskIndex: i, isChecked: next);
                          },
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            sub.name,
                            style: TextStyle(
                              fontSize: 16,
                              decoration: sub.isDone ? TextDecoration.lineThrough : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildAllModeList(List<TaskItem> tasks) {
    final sorted = _sortedByDateThenTime(tasks);

    final List<Widget> children = [];
    DateTime? lastDate;

    for (final t in sorted) {
      final taskDate = _taskDate(t);
      final currentDate = DateTime(taskDate.year, taskDate.month, taskDate.day);
      final isNewGroup = lastDate == null || !_isSameDay(currentDate, lastDate!);

      if (isNewGroup) {
        children.add(
          Text(
            _formatDayHeader(currentDate),
            style: const TextStyle(
              color: AppColors.blue,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
        children.add(const SizedBox(height: 2));
        lastDate = currentDate;
      }

      children.add(_taskRow(task: t));
    }

    children.add(const SizedBox(height: 120));
    return children;
  }

  List<Widget> _buildFilterModeList(List<TaskItem> tasks) {
    final sorted = _sortedByDateThenTime(tasks);
    return [
      ...sorted.map((t) => _taskRow(task: t)),
      const SizedBox(height: 120),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<TasksCubit, TasksState>(
        listener: (context, state) {
          if (state.warningMessage != null && state.warningMessage!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.warningMessage!)));
          }
          if (state.status == TasksStatus.failure) {
            final message = state.errorMessage ?? 'Failed to load tasks.';
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
          }
        },
        builder: (context, state) {
          final tasks = state.tasks;

          final bool hasSelectedDate = _selectedDate != null;
          final DateTime today = DateTime.now();

          final String dateLabel = hasSelectedDate ? _formatHeaderDate(_selectedDate!) : 'Today, ${_formatHeaderDate(today)}';

          final Color dateColor = hasSelectedDate ? AppColors.black : AppColors.lightGrey;
          final Color listIconColor = _showAll ? AppColors.black : AppColors.lightGrey;

          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Tasks',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() => _showAll = true);
                              },
                              child: Icon(
                                Icons.format_list_bulleted,
                                size: 24,
                                color: listIconColor,
                              ),
                            ),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () async {
                                final picked = await showModalBottomSheet<DateTime>(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (ctx) => FractionallySizedBox(
                                        heightFactor: 0.6,
                                        child: BlocProvider.value(
                                          value: _cubit,
                                          child: TaskDatePicker(
                                            initialDate: _selectedDate ?? DateTime.now(),
                                            onSelected: (d) => Navigator.of(ctx).pop(d),
                                          ),
                                        ),
                                      ),
                                );

                                if (picked != null && mounted) {
                                  setState(() {
                                    _selectedDate = picked;
                                    _showAll = false;
                                  });
                                }
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    AppVector.task,
                                    width: 24,
                                    height: 24,
                                    colorFilter: ColorFilter.mode(
                                      dateColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    dateLabel,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: dateColor,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 15,
                                    color: dateColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(height: 25),
                    Expanded(
                      child: state.status == TasksStatus.loading && tasks.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : tasks.isEmpty
                              ? const Center(
                                  child: Text(
                                    'No task',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.lightGrey,
                                    ),
                                  ),
                                )
                              : ListView(
                                  children: _showAll
                                      ? _buildAllModeList(tasks)
                                      : _buildFilterModeList(
                                          tasks.where((t) {
                                            final d = _taskDate(t);
                                            return _isSameDay(d, _selectedDate!);
                                          }).toList(),
                                        ),
                                ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
