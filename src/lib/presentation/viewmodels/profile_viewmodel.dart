import 'package:flutter/foundation.dart';
import 'package:the_code_cup/domain/models/user_profile.dart';
import 'package:the_code_cup/data/repositories/profile_repository.dart';
import 'package:the_code_cup/presentation/viewmodels/ui_models.dart';

class ProfileViewModel extends ChangeNotifier {
  final ProfileRepository _profileRepo;

  ProfileViewModel({required ProfileRepository profileRepo})
      : _profileRepo = profileRepo {
    _profileRepo.addListener(notifyListeners);
  }

  @override
  void dispose() {
    _profileRepo.removeListener(notifyListeners);
    super.dispose();
  }

  ProfileUi get profile {
    final p = _profileRepo.profile;
    return ProfileUi(
      name: p.name,
      email: p.email,
      phone: p.phone ?? '',
      address: p.address ?? '',
      avatarUrl: p.avatarUrl,
      initial: p.name.isNotEmpty ? p.name[0].toUpperCase() : '?',
    );
  }

  Future<String?> updateName(String value) => _profileRepo.update(
    UserProfile(name: value, email: _profileRepo.profile.email, phone: _profileRepo.profile.phone, avatarUrl: _profileRepo.profile.avatarUrl, address: _profileRepo.profile.address),
  );
  Future<String?> updatePhone(String value) => _profileRepo.update(
    UserProfile(name: _profileRepo.profile.name, email: _profileRepo.profile.email, phone: value, avatarUrl: _profileRepo.profile.avatarUrl, address: _profileRepo.profile.address),
  );
  Future<String?> updateEmail(String value) => _profileRepo.update(
    UserProfile(name: _profileRepo.profile.name, email: value, phone: _profileRepo.profile.phone, avatarUrl: _profileRepo.profile.avatarUrl, address: _profileRepo.profile.address),
  );
  Future<String?> updateAddress(String value) => _profileRepo.update(
    UserProfile(name: _profileRepo.profile.name, email: _profileRepo.profile.email, phone: _profileRepo.profile.phone, avatarUrl: _profileRepo.profile.avatarUrl, address: value),
  );
  Future<String?> updateAvatar(String value) => _profileRepo.update(
    UserProfile(name: _profileRepo.profile.name, email: _profileRepo.profile.email, phone: _profileRepo.profile.phone, avatarUrl: value, address: _profileRepo.profile.address),
  );
}
