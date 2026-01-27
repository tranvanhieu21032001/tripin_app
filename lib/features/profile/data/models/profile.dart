class Profile {
  final String fullName;
  final String email;
  final String branchName;
  final String? avatarUrl;

  final String firstName;
  final String lastName;
  final String mobile;
  final String birthdayLabel;
  final String gender;
  final String address;

  const Profile({
    required this.fullName,
    required this.email,
    required this.branchName,
    required this.avatarUrl,
    required this.firstName,
    required this.lastName,
    this.mobile = '',
    this.birthdayLabel = '',
    this.gender = '',
    this.address = '',
  });
}

