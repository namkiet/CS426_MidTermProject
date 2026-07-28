import 'package:flutter/material.dart';
import 'package:the_code_cup/viewmodels/home_viewmodel.dart';
import 'package:the_code_cup/views/home_screen.dart';
import 'package:the_code_cup/models/product.dart';

void main() {
  final homeViewModel = HomeViewModel();
  homeViewModel.setProducts([
    Product(
      name: 'Espresso',
      basePrice: 25000,
      availableCustomizations: {
        'size': {'Small': 0.0, 'Large': 5000.0},
        'shot': {'Single': 0.0, 'Double': 10000.0},
        'ice': {'Hot': 0.0, 'Iced': 0.0},
      },
    ),
    Product(
      name: 'Latte',
      basePrice: 35000,
      availableCustomizations: {
        'size': {'Small': 0.0, 'Large': 5000.0},
        'ice': {'Hot': 0.0, 'Iced': 0.0},
      },
    ),
    Product(
      name: 'Cappuccino',
      basePrice: 30000,
      availableCustomizations: {
        'size': {'Small': 0.0, 'Large': 5000.0},
        'shot': {'Single': 0.0, 'Double': 10000.0},
        'ice': {'Hot': 0.0, 'Iced': 0.0},
      },
    ),
  ]);

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: HomeScreen(viewModel: homeViewModel),
    );
  }
}
