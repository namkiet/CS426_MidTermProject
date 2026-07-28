class UserProfile {
  final String name;
  final String email;
  final String? phone;
  final String? avatarUrl;

  UserProfile({
    required this.name,
    required this.email,
    this.phone,
    this.avatarUrl,
  })  : assert(name.isNotEmpty),
      assert(_isValidEmail(email));

  static bool _isValidEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }
}
