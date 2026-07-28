import 'dart:async';

import 'package:flutter/material.dart';
import 'package:the_code_cup/constants/app_colors.dart';
import 'package:the_code_cup/navigation/app_navigator.dart';
import 'package:the_code_cup/services/local_storage.dart';
import 'package:the_code_cup/repositories/app_repository.dart';
import 'package:the_code_cup/viewmodels/app_view_models.dart';
import 'package:the_code_cup/widgets/app_scope.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();

  final repo = AppRepository()..loadPersisted();
  final vms = AppViewModels(repo);

  runApp(MyApp(vms: vms));
}

class MyApp extends StatefulWidget {
  final AppViewModels vms;

  const MyApp({super.key, required this.vms});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.vms.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Best-effort lifecycle persistence. Runtime changes already persist on
    // mutation, so resume does not force a reload.
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        unawaited(widget.vms.repo.persistAll());
        break;
      case AppLifecycleState.resumed:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      vms: widget.vms,
      child: MaterialApp(
        title: 'The Code Cup',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          useMaterial3: true,
        ),
        home: Builder(builder: (context) => AppNavigator.tab(context, 0)),
      ),
    );
  }
}
