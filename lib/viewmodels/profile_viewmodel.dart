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

  String? updateName(String value) => repo.updateName(value);
  String? updatePhone(String value) => repo.updatePhone(value);
  String? updateEmail(String value) => repo.updateEmail(value);
  String? updateAddress(String value) => repo.updateAddress(value);
  String? updateAvatar(String value) => repo.updateAvatar(value);
}
