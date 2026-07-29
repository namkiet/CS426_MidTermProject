import 'package:flutter/foundation.dart';
import 'package:the_code_cup/domain/models/user_profile.dart';
import 'package:the_code_cup/data/datasources/seed_data.dart';
import 'package:the_code_cup/data/preferences/local_storage.dart';

class ProfileRepository extends ChangeNotifier {
  UserProfile profile = SeedData.defaultProfile;

  Future<void> load() async {
    profile = LocalStorage.loadUserProfile() ?? SeedData.defaultProfile;
    notifyListeners();
  }

  Future<void> persist() => LocalStorage.saveUserProfile(profile);

  Future<String?> update(UserProfile updated) async {
    try {
      profile = updated;
      await persist();
      notifyListeners();
      return null;
    } on ArgumentError {
      return 'Invalid value for this field';
    }
  }
}
