import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/timesheet_item.dart';

@lazySingleton
class TimesheetLocalDataSource {
  static const _timesheetsKey = 'timesheets_cache';

  final SharedPreferences _prefs;

  TimesheetLocalDataSource(this._prefs);

  Future<void> saveTimesheets(List<TimesheetItem> timesheets) async {
    final payload = timesheets.map((e) => e.toJson()).toList();
    await _prefs.setString(_timesheetsKey, jsonEncode(payload));
  }

  List<TimesheetItem> getCachedTimesheets() {
    final raw = _prefs.getString(_timesheetsKey);
    if (raw == null || raw.isEmpty) {
      return const <TimesheetItem>[];
    }
    final decoded = jsonDecode(raw);
    if (decoded is! List) {
      return const <TimesheetItem>[];
    }
    return decoded
        .whereType<Map>()
        .map((e) => TimesheetItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> clearTimesheets() async {
    await _prefs.remove(_timesheetsKey);
  }
}
