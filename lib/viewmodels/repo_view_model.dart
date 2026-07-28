import 'package:flutter/foundation.dart';
import 'package:the_code_cup/repositories/app_repository.dart';

abstract class RepoViewModel extends ChangeNotifier {
  final AppRepository repo;

  RepoViewModel(this.repo) {
    repo.addListener(notifyListeners);
  }

  @override
  void dispose() {
    repo.removeListener(notifyListeners);
    super.dispose();
  }
}
