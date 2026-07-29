import 'package:the_code_cup/models/user_profile.dart';
import 'package:the_code_cup/viewmodels/repo_view_model.dart';
import 'package:the_code_cup/viewmodels/ui_models.dart';

class ProfileViewModel extends RepoViewModel {
  ProfileViewModel(super.repo);

  ProfileUi get profile {
    final p = repo.userProfile;
    return ProfileUi(
      name: p.name,
      email: p.email,
      phone: p.phone ?? '',
      address: p.address ?? '',
      avatarUrl: p.avatarUrl,
      initial: p.name.isNotEmpty ? p.name[0].toUpperCase() : '?',
    );
  }

  Future<String?> updateName(String value) => repo.updateProfile(
    UserProfile(name: value, email: repo.userProfile.email, phone: repo.userProfile.phone, avatarUrl: repo.userProfile.avatarUrl, address: repo.userProfile.address),
  );
  Future<String?> updatePhone(String value) => repo.updateProfile(
    UserProfile(name: repo.userProfile.name, email: repo.userProfile.email, phone: value, avatarUrl: repo.userProfile.avatarUrl, address: repo.userProfile.address),
  );
  Future<String?> updateEmail(String value) => repo.updateProfile(
    UserProfile(name: repo.userProfile.name, email: value, phone: repo.userProfile.phone, avatarUrl: repo.userProfile.avatarUrl, address: repo.userProfile.address),
  );
  Future<String?> updateAddress(String value) => repo.updateProfile(
    UserProfile(name: repo.userProfile.name, email: repo.userProfile.email, phone: repo.userProfile.phone, avatarUrl: repo.userProfile.avatarUrl, address: value),
  );
  Future<String?> updateAvatar(String value) => repo.updateProfile(
    UserProfile(name: repo.userProfile.name, email: repo.userProfile.email, phone: repo.userProfile.phone, avatarUrl: value, address: repo.userProfile.address),
  );
}
