import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wemu_team_app/core/configs/theme/app_colors.dart';
import 'package:wemu_team_app/core/constants/task_status_constants.dart';
import 'package:wemu_team_app/features/chat/pages/chat_page.dart';
import 'package:wemu_team_app/features/tasks/data/models/task_item.dart';
import 'package:wemu_team_app/features/tasks/presentation/bloc/tasks_cubit.dart';
import 'package:wemu_team_app/features/tasks/presentation/bloc/tasks_state.dart';
import 'package:wemu_team_app/widgets/checkbox/circle_check.dart';
import 'package:wemu_team_app/widgets/user_profile/user_profile.dart';

class TaskDetailSheet extends StatelessWidget {
  final TasksCubit cubit;
  final String taskId;

  const TaskDetailSheet({
    super.key,
    required this.cubit,
    required this.taskId,
  });

  static Future<void> show({
    required BuildContext context,
    required TasksCubit cubit,
    required String taskId,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.introOverlay,
      builder: (context) => BlocProvider.value(
        value: cubit,
        child: TaskDetailSheet(
          cubit: cubit,
          taskId: taskId,
        ),
      ),
    );
  }

  static void _showTopToast({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
  }) {
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) {
        final topPadding = MediaQuery.of(ctx).padding.top;
        return Positioned(
          top: topPadding + 12,
          left: 16,
          right: 16,
          child: Material(
            color: Colors.transparent,
            child: SafeArea(
              bottom: false,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 2), () {
      entry.remove();
    });
  }

  static String _stripError(Object error) {
    String message = error.toString();
    final prefixIndex = message.indexOf(': ');
    if (prefixIndex != -1) {
      final stripped = message.substring(prefixIndex + 2).trim();
      if (stripped.isNotEmpty) {
        message = stripped;
      }
    }
    return message;
  }

  Future<void> _openDuePicker(BuildContext context, TaskItem task) async {
    final initial = task.startAt ?? DateTime.now();
    final initialDate = DateTime(initial.year, initial.month, initial.day);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        DateTime selectedDate = initialDate;

        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            final duration = (task.startAt != null && task.endAt != null)
                ? task.endAt!.difference(task.startAt!)
                : Duration.zero;

            return SafeArea(
              top: false,
              child: SizedBox(
                height: MediaQuery.of(sheetContext).size.height * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Center(
                      child: Container(
                        width: 48,
                        height: 5,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0E0E0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Due',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 320,
                      child: CalendarDatePicker(
                        initialDate: selectedDate,
                        firstDate: DateTime(selectedDate.year - 5),
                        lastDate: DateTime(DateTime.now().year + 5),
                        currentDate: DateTime.now(),
                        onDateChanged: (date) {
                          setSheetState(() {
                            selectedDate = DateTime(date.year, date.month, date.day);
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        DateFormat('MMM d, yyyy').format(selectedDate),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: FutureBuilder<List<String>>(
                        key: ValueKey<String>(selectedDate.toIso8601String()),
                        future: cubit.getAvailableTimes(taskId: task.id, date: selectedDate),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          if (snapshot.hasError) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  _stripError(snapshot.error!),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: AppColors.grey),
                                ),
                              ),
                            );
                          }

                          final items = snapshot.data ?? const <String>[];
                          if (items.isEmpty) {
                            return const Center(
                              child: Text(
                                'No available times',
                                style: TextStyle(color: AppColors.grey),
                              ),
                            );
                          }

                          return ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            itemCount: items.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final startAt = DateTime.tryParse(items[index]);
                              if (startAt == null) {
                                return const SizedBox.shrink();
                              }
                              final endAt = duration == Duration.zero ? null : startAt.add(duration);

                              final timeLabel = endAt == null
                                  ? DateFormat('h:mm a').format(startAt)
                                  : '${DateFormat('h:mm a').format(startAt)} - ${DateFormat('h:mm a').format(endAt)}';

                              return InkWell(
                                onTap: () async {
                                  try {
                                    await cubit.updateTaskTime(task: task, startAt: startAt);

                                    if (!context.mounted) return;

                                    Navigator.of(context).pop();

                                    _showTopToast(
                                      context: context,
                                      message: 'Task has been successfully updated!',
                                      backgroundColor: const Color(0xFFE5F8D6),
                                    );
                                  } catch (e) {
                                    if (!context.mounted) return;

                                    _showTopToast(
                                      context: context,
                                      message: _stripError(e),
                                      backgroundColor: const Color(0xFFFFE1E1),
                                    );
                                  }
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF3F3F3),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    timeLabel,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksCubit, TasksState>(
      builder: (context, state) {
        final task = state.tasks.where((t) => t.id == taskId).cast<TaskItem?>().firstWhere(
              (t) => t != null,
              orElse: () => null,
            );

        if (task == null) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text('Task not found or has been removed.', textAlign: TextAlign.center),
            ),
          );
        }

        final subTaskStartIndex = task.isServiceTask ? 0 : 1;
        final hasSubtasksToRender = task.subTasks.length > subTaskStartIndex;

        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Column(
                children: [
                  _buildHeader(context, task),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          if (hasSubtasksToRender) ...[
                            _buildSectionTitle('Subtasks', '(${task.subTasks.length - subTaskStartIndex})'),
                            _buildSubtasks(task, subTaskStartIndex),
                            const SizedBox(height: 8),
                          ],
                          _buildSectionTitle('Assigned to', ''),
                          const SizedBox(height: 8),
                          _buildUserRow(task.employeeName, task.employeeAvatarUrl),
                          const SizedBox(height: 16),
                          _buildSectionTitle('Created by', ''),
                          const SizedBox(height: 8),
                          _buildUserRow(task.userName, task.userAvatarUrl),
                          const SizedBox(height: 24),
                          _buildSectionTitle('Status', ''),
                          _buildStatusChip(context, task),
                          const SizedBox(height: 16),
                          _buildSectionTitle('Due', ''),
                          _buildDueDate(context, task),
                          if (task.notes != null && task.notes!.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            _buildSectionTitle('Notes', ''),
                            _buildNotes(task.notes!),
                          ],
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                  _buildBottomButtons(context, task),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, TaskItem task) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 32, 18, 4),
      child: Column(
        children: [
          Row(
            children: [
              CircleCheck(
                done: task.isCompleted,
                onTap: () => cubit.toggleTaskComplete(task: task, isChecked: !task.isCompleted),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  task.displayTitle,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_horiz),
                color: AppColors.black,
                onPressed: () {},
              ),
            ],
          ),
          const Divider(color: AppColors.lightGrey, height: 1),
        ],
      ),
    );
  }

  Widget _buildNotes(String notes) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        notes,
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, String count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.grey,
            ),
          ),
          if (count.isNotEmpty) Text(count, style: const TextStyle(fontSize: 16, color: AppColors.grey)),
        ],
      ),
    );
  }

  Widget _buildSubtasks(TaskItem task, int subTaskStartIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: List.generate(task.subTasks.length - subTaskStartIndex, (idx) {
          final i = idx + subTaskStartIndex;
          final sub = task.subTasks[i];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                CircleCheck(
                  done: sub.isDone,
                  onTap: () => cubit.toggleSubTask(task: task, subTaskIndex: i, isChecked: !sub.isDone),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    sub.name,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.black,
                      decoration: sub.isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildUserRow(String name, String? avatarUrl) {
    return UserProfile(
      name: name.isNotEmpty ? name : '—',
      backgroundUrl: avatarUrl,
    );
  }

  Widget _buildStatusChip(BuildContext context, TaskItem task) {
    final status = task.status;
    final statusText = TaskStatusConstants.getStatusText(status);
    final bgColor = Color(TaskStatusConstants.getStatusBackgroundColor(status));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: PopupMenuButton<String>(
        onSelected: (selectedStatus) async {
          if (selectedStatus == status) return;

          try {
            await cubit.changeStatusTask(
              taskId: task.id,
              status: selectedStatus,
            );

            if (!context.mounted) return;

            _showTopToast(
              context: context,
              message: 'Task has been successfully updated!',
              backgroundColor: Color(TaskStatusConstants.getStatusBackgroundColor(selectedStatus)),
            );
          } catch (e) {
            if (!context.mounted) return;

            _showTopToast(
              context: context,
              message: _stripError(e),
              backgroundColor: const Color(0xFFFFE1E1),
            );
          }
        },
        itemBuilder: (context) {
          return TaskStatusConstants.allStatuses
              .where((s) => s != status)
              .map(
                (s) => PopupMenuItem<String>(
                  value: s,
                  child: Text(TaskStatusConstants.getStatusText(s)),
                ),
              )
              .toList();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                statusText,
                style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.keyboard_arrow_down, size: 20, color: AppColors.black),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDueDate(BuildContext context, TaskItem task) {
    final startAt = task.startAt;
    final endAt = task.endAt;

    final dueFormat = DateFormat('MMM d, yyyy');
    final timeFormat = DateFormat('h:mm a');

    String dueDateText;
    if (startAt != null && endAt != null) {
      dueDateText = '${dueFormat.format(startAt)}, ${timeFormat.format(startAt)} - ${timeFormat.format(endAt)}';
    } else if (startAt != null) {
      dueDateText = '${dueFormat.format(startAt)}, ${timeFormat.format(startAt)}';
    } else {
      dueDateText = 'No due date';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: () => _openDuePicker(context, task),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
          decoration: BoxDecoration(
            color: const Color(0xFFECECEC),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                dueDateText,
                style: const TextStyle(color: AppColors.black, fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.keyboard_arrow_down, size: 20, color: AppColors.black),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context, TaskItem task) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: OutlinedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                reservationId: task.id,
                taskTitle: task.displayTitle,
                commentsCount: 0,
              ),
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFFF3F3F3),
          padding: const EdgeInsets.symmetric(vertical: 12),
          side: const BorderSide(color: AppColors.gray),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.blue,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Text(
                '0',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Messages',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
