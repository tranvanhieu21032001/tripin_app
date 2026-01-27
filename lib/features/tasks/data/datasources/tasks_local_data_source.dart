import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/task_item.dart';

@lazySingleton
class TasksLocalDataSource {
  static const _tasksKey = 'tasks_cache';

  final SharedPreferences _prefs;

  TasksLocalDataSource(this._prefs);

  Future<void> saveTasks(List<TaskItem> tasks) async {
    final payload = tasks.map((e) => e.toJson()).toList();
    await _prefs.setString(_tasksKey, jsonEncode(payload));
  }

  List<TaskItem> getCachedTasks() {
    final raw = _prefs.getString(_tasksKey);
    if (raw == null || raw.isEmpty) {
      return const <TaskItem>[];
    }
    final decoded = jsonDecode(raw);
    if (decoded is! List) {
      return const <TaskItem>[];
    }
    return decoded
        .whereType<Map>()
        .map((e) => TaskItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> clearTasks() async {
    await _prefs.remove(_tasksKey);
  }
}
