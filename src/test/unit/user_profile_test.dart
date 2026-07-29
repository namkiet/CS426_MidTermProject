import 'package:flutter_test/flutter_test.dart';
import 'package:the_code_cup/domain/models/user_profile.dart';

void main() {
  group('UserProfile', () {
    test('create profile with name, email, phone, avatar', () {
      final profile = UserProfile(
        name: 'Nam Kiet',
        email: 'kiet@example.com',
        phone: '0912345678',
        avatarUrl: 'https://example.com/avatar.png',
      );
      expect(profile.name, 'Nam Kiet');
      expect(profile.email, 'kiet@example.com');
      expect(profile.phone, '0912345678');
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
      final updated = UserProfile(
        name: profile.name,
        email: profile.email,
        phone: '0987654321',
      );
      expect(updated.phone, '0987654321');
    });

    test('update avatar', () {
      final profile = UserProfile(name: 'Test', email: 'a@b.com');
      final updated = UserProfile(
        name: profile.name,
        email: profile.email,
        avatarUrl: 'https://example.com/new.png',
      );
      expect(updated.avatarUrl, 'https://example.com/new.png');
    });

    test('reject empty name', () {
      expect(
        () => UserProfile(name: '', email: 'a@b.com'),
        throwsArgumentError,
      );
    });

    test('reject invalid email', () {
      expect(
        () => UserProfile(name: 'Test', email: 'not-an-email'),
        throwsArgumentError,
      );
    });

    test('accept valid emails', () {
      UserProfile(name: 'Test', email: 'user@example.com');
      UserProfile(name: 'Test', email: 'user.name@example.co.vn');
    });

    // ── Phone validation ──

    test('accept valid VN phone number starting with 0', () {
      UserProfile(name: 'A', email: 'a@b.com', phone: '0912345678');
    });

    test('accept valid VN phone starting with 03/07/08/09', () {
      UserProfile(name: 'A', email: 'a@b.com', phone: '0351234567');
      UserProfile(name: 'B', email: 'b@b.com', phone: '0771234567');
      UserProfile(name: 'C', email: 'c@b.com', phone: '0861234567');
    });

    test('reject phone shorter than 10 digits', () {
      expect(
        () => UserProfile(name: 'A', email: 'a@b.com', phone: '091234567'),
        throwsArgumentError,
      );
    });

    test('reject phone longer than 10 digits', () {
      expect(
        () => UserProfile(name: 'A', email: 'a@b.com', phone: '09123456789'),
        throwsArgumentError,
      );
    });

    test('reject phone not starting with 0', () {
      expect(
        () => UserProfile(name: 'A', email: 'a@b.com', phone: '1912345678'),
        throwsArgumentError,
      );
    });

    test('accept null phone (optional field)', () {
      UserProfile(name: 'A', email: 'a@b.com');
    });
  });
}
