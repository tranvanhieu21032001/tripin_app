import 'package:equatable/equatable.dart';

import '../../data/models/timesheet_item.dart';

enum TimesheetStatus { initial, loading, success, failure }

enum TimesheetMembersStatus { initial, loading, success, failure }

enum TimesheetCreateStatus { initial, loading, success, failure }

class TimesheetState extends Equatable {
  final TimesheetStatus status;
  final List<TimesheetItem> timesheets;
  final String? errorMessage;
  final String? warningMessage;

  final TimesheetMembersStatus membersStatus;
  final List<Map<String, dynamic>> members;
  final String? membersErrorMessage;

  final TimesheetCreateStatus createStatus;
  final String? createErrorMessage;

  const TimesheetState({
    this.status = TimesheetStatus.initial,
    this.timesheets = const [],
    this.errorMessage,
    this.warningMessage,
    this.membersStatus = TimesheetMembersStatus.initial,
    this.members = const [],
    this.membersErrorMessage,
    this.createStatus = TimesheetCreateStatus.initial,
    this.createErrorMessage,
  });

  TimesheetState copyWith({
    TimesheetStatus? status,
    List<TimesheetItem>? timesheets,
    String? errorMessage,
    String? warningMessage,
    TimesheetMembersStatus? membersStatus,
    List<Map<String, dynamic>>? members,
    String? membersErrorMessage,
    TimesheetCreateStatus? createStatus,
    String? createErrorMessage,
  }) {
    return TimesheetState(
      status: status ?? this.status,
      timesheets: timesheets ?? this.timesheets,
      errorMessage: errorMessage,
      warningMessage: warningMessage,
      membersStatus: membersStatus ?? this.membersStatus,
      members: members ?? this.members,
      membersErrorMessage: membersErrorMessage,
      createStatus: createStatus ?? this.createStatus,
      createErrorMessage: createErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        timesheets,
        errorMessage,
        warningMessage,
        membersStatus,
        members,
        membersErrorMessage,
        createStatus,
        createErrorMessage,
      ];
}
