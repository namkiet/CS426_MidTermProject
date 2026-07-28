import 'package:flutter/material.dart';
import 'package:the_code_cup/viewmodels/home_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  final HomeViewModel viewModel;

  const HomeScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('The Code Cup')),
      body: ListView.builder(
        itemCount: viewModel.products.length,
        itemBuilder: (context, index) {
          final product = viewModel.products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('${product.basePrice} VND'),
          );
        },
      ),
    );
  }
}
