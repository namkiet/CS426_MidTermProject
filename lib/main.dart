import 'package:flutter/material.dart';
import 'package:the_code_cup/constants/app_colors.dart';
import 'package:the_code_cup/data/seed_data.dart';
import 'package:the_code_cup/services/local_storage.dart';
import 'package:the_code_cup/viewmodels/home_viewmodel.dart';
import 'package:the_code_cup/views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();

  final homeViewModel = HomeViewModel();
  homeViewModel.setProducts(SeedData.products);
  homeViewModel.loadPersistedState();

  runApp(MyApp(homeViewModel: homeViewModel));
}

class MyApp extends StatelessWidget {
  final HomeViewModel homeViewModel;

  const MyApp({super.key, required this.homeViewModel});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Code Cup',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      home: HomeScreen(viewModel: homeViewModel),
    );
 }
}
