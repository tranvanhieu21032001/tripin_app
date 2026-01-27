import 'package:equatable/equatable.dart';

import '../../data/models/task_item.dart';
import '../../data/models/task_summary.dart';

enum TasksStatus { initial, loading, success, failure }

class TasksState extends Equatable {
  final TasksStatus status;
  final List<TaskItem> tasks;
  final String? errorMessage;
  final String? warningMessage;
  final TaskSummary? summary;
  final int weeklyHours;

  const TasksState({
    this.status = TasksStatus.initial,
    this.tasks = const [],
    this.errorMessage,
    this.warningMessage,
    this.summary,
    this.weeklyHours = 0,
  });

  TasksState copyWith({
    TasksStatus? status,
    List<TaskItem>? tasks,
    String? errorMessage,
    String? warningMessage,
    TaskSummary? summary,
    int? weeklyHours,
  }) {
    return TasksState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      errorMessage: errorMessage,
      warningMessage: warningMessage,
      summary: summary ?? this.summary,
      weeklyHours: weeklyHours ?? this.weeklyHours,
    );
  }

  @override
  List<Object?> get props => [status, tasks, errorMessage, warningMessage, summary, weeklyHours];
}
