class Branch {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String slug;
  final bool isDefault;
  final bool subscribed;
  final Map<String, dynamic> address;

  const Branch({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.slug,
    required this.isDefault,
    required this.subscribed,
    required this.address,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    final address = json['address'];
    return Branch(
      id: (json['_id'] as String?) ?? '',
      name: (json['name'] as String?) ?? '',
      email: (json['email'] as String?) ?? '',
      phone: (json['phone'] as String?) ?? '',
      slug: (json['slug'] as String?) ?? '',
      isDefault: json['isDefault'] == true,
      subscribed: json['subscribed'] == true,
      address: address is Map<String, dynamic> ? address : const {},
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'slug': slug,
        'isDefault': isDefault,
        'subscribed': subscribed,
        'address': address,
      };
}
