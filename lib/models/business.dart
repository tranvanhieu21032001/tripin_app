class Business {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String slug;
  final String logo;
  final bool active;
  final Map<String, dynamic> address;

  const Business({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.slug,
    required this.logo,
    required this.active,
    required this.address,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    final address = json['address'];
    return Business(
      id: (json['_id'] as String?) ?? '',
      name: (json['name'] as String?) ?? '',
      email: (json['email'] as String?) ?? '',
      phone: (json['phone'] as String?) ?? '',
      slug: (json['slug'] as String?) ?? '',
      logo: (json['logo'] as String?) ?? '',
      active: json['active'] == true,
      address: address is Map<String, dynamic> ? address : const {},
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'slug': slug,
        'logo': logo,
        'active': active,
        'address': address,
      };
}
