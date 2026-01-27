import 'branch.dart';
import 'business.dart';

class Permission {
  final List<Branch> branches;
  final Business? business;
  final Map<String, List<String>> permission;
  final String id;
  final bool subscribed;
  final String user;
  final String role;
  final String updatedAt;

  Permission({
    required this.branches,
    required this.business,
    required this.permission,
    required this.id,
    required this.subscribed,
    required this.user,
    required this.role,
    required this.updatedAt,
  });

  factory Permission.fromJson(Map<String, dynamic> json) {
    final branchesJson = json['branches'];
    final branches = branchesJson is List
        ? branchesJson
            .whereType<Map>()
            .map((e) => Branch.fromJson(Map<String, dynamic>.from(e)))
            .toList()
        : <Branch>[];

    final businessJson = json['business'];
    final business = businessJson is Map<String, dynamic>
        ? Business.fromJson(businessJson)
        : null;

    final permissionJson = json['permission'];
    final permission = <String, List<String>>{};
    if (permissionJson is Map) {
      for (final entry in permissionJson.entries) {
        final key = entry.key?.toString() ?? '';
        if (key.isEmpty) continue;
        final value = entry.value;
        if (value is List) {
          permission[key] = value.whereType<String>().toList();
        }
      }
    }

    return Permission(
      branches: branches,
      business: business,
      permission: permission,
      id: (json['_id'] as String?) ?? '',
      subscribed: json['subscribed'] == true,
      user: (json['user'] as String?) ?? '',
      role: (json['role'] as String?) ?? '',
      updatedAt: (json['updatedAt'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'subscribed': subscribed,
        'user': user,
        'role': role,
        'updatedAt': updatedAt,
        'branches': branches.map((b) => b.toJson()).toList(),
        'business': business?.toJson(),
        'permission': permission,
      };
}
