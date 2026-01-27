import 'package:wemu_team_app/models/permission.dart';
import 'package:wemu_team_app/models/user_profile.dart';

class LoginResponse {
  final String token;
  final UserProfile user;
  final List<Permission> permissions;

  const LoginResponse({
    required this.token,
    required this.user,
    required this.permissions,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Invalid login response format.');
    }
    final token = data['token'];
    if (token is! String || token.isEmpty) {
      throw const FormatException('Missing token in login response.');
    }
    final userJson = data['user'];
    if (userJson is! Map<String, dynamic>) {
      throw const FormatException('Missing user in login response.');
    }
    final permissionsJson = data['permissions'];
    final permissions = permissionsJson is List
        ? permissionsJson
            .whereType<Map>()
            .map((e) => Permission.fromJson(Map<String, dynamic>.from(e)))
            .toList()
        : <Permission>[];
    return LoginResponse(
      token: token,
      user: UserProfile.fromJson(userJson),
      permissions: permissions,
    );
  }
}
