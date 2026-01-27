class TimesheetItem {
  final String id;
  final String status;
  final DateTime? clockinTime;
  final DateTime? clockoutTime;
  final DateTime? createdAt;
  final num total;

  const TimesheetItem({
    required this.id,
    required this.status,
    required this.clockinTime,
    required this.clockoutTime,
    required this.createdAt,
    required this.total,
  });

  factory TimesheetItem.fromJson(Map<String, dynamic> json) {
    return TimesheetItem(
      id: (json['_id'] as String?) ?? '',
      status: (json['status'] as String?) ?? '',
      clockinTime: DateTime.tryParse(json['clockinTime']?.toString() ?? ''),
      clockoutTime: DateTime.tryParse(json['clockoutTime']?.toString() ?? ''),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      total: json['total'] is num ? json['total'] as num : 0,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'status': status,
        'clockinTime': clockinTime?.toIso8601String(),
        'clockoutTime': clockoutTime?.toIso8601String(),
        'createdAt': createdAt?.toIso8601String(),
        'total': total,
      };
}
