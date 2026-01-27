class TaskSubTask {
  final String name;
  final String status;

  const TaskSubTask({
    required this.name,
    required this.status,
  });

  bool get isDone => status.toLowerCase() == 'done';

  factory TaskSubTask.fromJson(Map<String, dynamic> json) {
    return TaskSubTask(
      name: (json['name'] as String?) ?? '',
      status: (json['status'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'status': status,
      };
}

class TaskItem {
  final String id;
  final String status;
  final String confirmationStatus;
  final DateTime? startAt;
  final DateTime? endAt;
  final String relatedServiceName;
  final String branchName;
  final String contactName;
  final String userName;
  final String? userAvatarUrl;
  final String employeeName;
  final String? employeeAvatarUrl;
  final String? notes;
  final List<TaskSubTask> subTasks;
  final List<Map<String, dynamic>> services;

  const TaskItem({
    required this.id,
    required this.status,
    required this.confirmationStatus,
    required this.startAt,
    required this.endAt,
    required this.relatedServiceName,
    required this.branchName,
    required this.contactName,
    required this.userName,
    this.userAvatarUrl,
    required this.employeeName,
    this.employeeAvatarUrl,
    this.notes,
    required this.subTasks,
    required this.services,
  });

  factory TaskItem.fromJson(Map<String, dynamic> json) {
    final rawSubTasks = json['subTasks'];
    final subTasks = rawSubTasks is List
        ? rawSubTasks
            .whereType<Map>()
            .map((e) => TaskSubTask.fromJson(Map<String, dynamic>.from(e)))
            .toList()
        : <TaskSubTask>[];

    final contactName = _extractContactName(json['contactInfo']);
    final user = _extractUser(json['createdBy']);
    final employee = _extractUser(json['employee']);

    final rawServices = json['services'];
    final services = rawServices is List
        ? rawServices
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList()
        : const <Map<String, dynamic>>[];

    return TaskItem(
      id: (json['_id'] as String?) ?? '',
      status: (json['status'] as String?) ?? '',
      confirmationStatus: (json['confirmationStatus'] as String?) ?? '',
      startAt: DateTime.tryParse(json['startAt']?.toString() ?? ''),
      endAt: DateTime.tryParse(json['endAt']?.toString() ?? ''),
      relatedServiceName: (json['relatedServiceName'] as String?) ?? '',
      branchName: (json['branchName'] as String?) ?? '',
      notes: (json['notes'] as String?) ?? '',
      contactName: contactName,
      userName: user['name'] ?? '',
      userAvatarUrl: user['avatar'],
      employeeName: employee['name'] ?? 'No One',
      employeeAvatarUrl: employee['avatar'],
      subTasks: subTasks,
      services: services,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'status': status,
        'confirmationStatus': confirmationStatus,
        'startAt': startAt?.toIso8601String(),
        'endAt': endAt?.toIso8601String(),
        'relatedServiceName': relatedServiceName,
        'branchName': branchName,
        'contactInfo': contactName.isEmpty ? null : {'name': contactName},
        'user': {'name': userName, 'avatar': userAvatarUrl},
        'employee': {'name': employeeName, 'avatar': employeeAvatarUrl},
        'notes': notes,
        'subTasks': subTasks.map((s) => s.toJson()).toList(),
        'services': services,
      };

  static String _extractContactName(Object? contact) {
    if (contact is Map<String, dynamic>) {
      return contact['name']?.toString() ?? '';
    }
    return '';
  }

  static Map<String, String?> _extractUser(Object? user) {
    if (user is Map<String, dynamic>) {
      final name = user['name']?.toString() ??
          [user['firstName']?.toString() ?? '', user['lastName']?.toString() ?? '']
              .where((part) => part.trim().isNotEmpty)
              .join(' ')
              .trim();
      final avatar = user['avatar']?.toString();
      return {'name': name, 'avatar': avatar};
    }
    return {'name': '', 'avatar': null};
  }

  String get displayTitle {
    if (isServiceTask) {
      return relatedServiceName;
    }
    if (subTasks.isNotEmpty) {
      return subTasks.first.name;
    }
    return 'Task';
  }

  bool get isCompleted => status.toLowerCase() == 'completed';

  bool get isServiceTask => services.isNotEmpty;

}
