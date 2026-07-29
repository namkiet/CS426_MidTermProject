class UserProfile {
  final String name;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final String? address;

  UserProfile({
    required this.name,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.address,
  }) {
    if (name.isEmpty) {
      throw ArgumentError.value(name, 'name', 'Must not be empty');
    }
    if (!isValidEmail(email)) {
      throw ArgumentError.value(email, 'email', 'Must be a valid email');
    }
    if (!isValidPhone(phone)) {
      throw ArgumentError.value(phone, 'phone', 'Must be a valid VN phone');
    }
  }

  static bool isValidEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }

  static bool isValidPhone(String? phone) {
    if (phone == null || phone.isEmpty) return true;
    return RegExp(r'^0[35789]\d{8}$').hasMatch(phone);
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'phone': phone,
    'avatarUrl': avatarUrl,
    'address': address,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    name: json['name'] as String,
    email: json['email'] as String,
    phone: json['phone'] as String?,
    avatarUrl: json['avatarUrl'] as String?,
    address: json['address'] as String?,
  );
}
