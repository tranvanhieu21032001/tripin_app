class UserProfile {
  final String id;
  final List<String> roles;
  final String firstName;
  final String lastName;
  final String email;
  final String lastAccess;
  final bool isOnline;
  final String about;
  final String avatar;

  const UserProfile({
    required this.id,
    required this.roles,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.lastAccess,
    required this.isOnline,
    required this.about,
    required this.avatar,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final roles = json['roles'];
    return UserProfile(
      id: (json['_id'] as String?) ?? '',
      roles: roles is List ? roles.whereType<String>().toList() : const [],
      firstName: (json['firstName'] as String?) ?? '',
      lastName: (json['lastName'] as String?) ?? '',
      email: (json['email'] as String?) ?? '',
      lastAccess: (json['lastAccess'] as String?) ?? '',
      isOnline: (json['isOnline'] as bool?) ?? false,
      about: (json['about'] as String?) ?? '',
      avatar: (json['avatar'] as String?) ?? '',
    );
  }

  String get displayName {
    final name = [firstName, lastName].where((part) => part.trim().isNotEmpty).join(' ').trim();
    return name;
  }

  String get displayNameOrGuest => displayName.isEmpty ? 'Guest' : displayName;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'roles': roles,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'lastAccess': lastAccess,
        'isOnline': isOnline,
        'about': about,
        'avatar': avatar,
      };
}
