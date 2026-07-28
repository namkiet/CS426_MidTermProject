import 'package:flutter/material.dart';
import 'package:the_code_cup/constants/app_colors.dart';
import 'package:the_code_cup/models/user_profile.dart';
import 'package:the_code_cup/widgets/app_shell.dart';

class OrdersScreen extends StatelessWidget {
  final UserProfile userProfile;

  const OrdersScreen({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentIndex: 2,
      userProfile: userProfile,
      appBar: AppBar(
        title: const Text('Orders'),
        backgroundColor: AppColors.background,
      ),
      body: const Center(child: Text('Orders')),
    );
  }
}
