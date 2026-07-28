import 'package:flutter/material.dart';
import 'package:the_code_cup/viewmodels/app_view_models.dart';

/// Composition root access for navigation / AppBottomNav only.
/// Screens still take their own ViewModel for state & intents.
class AppScope extends InheritedWidget {
  final AppViewModels vms;

  const AppScope({super.key, required this.vms, required super.child});

  static AppViewModels of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found');
    return scope!.vms;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) => vms != oldWidget.vms;
}
