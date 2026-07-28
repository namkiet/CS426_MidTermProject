import 'package:flutter_test/flutter_test.dart';
import 'package:the_code_cup/models/user_profile.dart';

void main() {
  group('UserProfile', () {
    test('create profile with name, email, phone, avatar', () {
      final profile = UserProfile(
        name: 'Nam Kiet',
        email: 'kiet@example.com',
        phone: '0123456789',
        avatarUrl: 'https://example.com/avatar.png',
      );
      expect(profile.name, 'Nam Kiet');
      expect(profile.email, 'kiet@example.com');
      expect(profile.phone, '0123456789');
      expect(profile.avatarUrl, 'https://example.com/avatar.png');
    });

    test('update name', () {
      final profile = UserProfile(name: 'Old', email: 'old@example.com');
      final updated = UserProfile(name: 'New', email: profile.email);
      expect(updated.name, 'New');
      expect(updated.email, 'old@example.com');
    });

    test('update email', () {
      final profile = UserProfile(name: 'Test', email: 'old@example.com');
      final updated = UserProfile(name: profile.name, email: 'new@example.com');
      expect(updated.email, 'new@example.com');
    });

    test('update phone', () {
      final profile = UserProfile(name: 'Test', email: 'a@b.com');
      final updated = UserProfile(name: profile.name, email: profile.email, phone: '0987654321');
      expect(updated.phone, '0987654321');
    });

    test('update avatar', () {
      final profile = UserProfile(name: 'Test', email: 'a@b.com');
      final updated = UserProfile(name: profile.name, email: profile.email, avatarUrl: 'https://example.com/new.png');
      expect(updated.avatarUrl, 'https://example.com/new.png');
    });

    test('reject empty name', () {
      expect(
        () => UserProfile(name: '', email: 'a@b.com'),
        throwsAssertionError,
      );
    });

    test('reject invalid email', () {
      expect(
        () => UserProfile(name: 'Test', email: 'not-an-email'),
        throwsAssertionError,
      );
    });

    test('accept valid emails', () {
      UserProfile(name: 'Test', email: 'user@example.com');
      UserProfile(name: 'Test', email: 'user.name@example.co.vn');
    });
  });
}
