import 'package:flutter/material.dart';
import 'package:the_code_cup/constants/app_colors.dart';
import 'package:the_code_cup/models/user_profile.dart';
import 'package:the_code_cup/viewmodels/home_viewmodel.dart';
import 'package:the_code_cup/views/home_screen.dart';
import 'package:the_code_cup/views/orders_screen.dart';
import 'package:the_code_cup/views/profile_screen.dart';
import 'package:the_code_cup/views/rewards_screen.dart';

class AppShell extends StatelessWidget {
  final int currentIndex;
  final UserProfile userProfile;
  final HomeViewModel? viewModel;
  final PreferredSizeWidget? appBar;
  final Widget body;

  const AppShell({
    super.key,
    required this.currentIndex,
    required this.userProfile,
    this.viewModel,
    this.appBar,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: appBar,
      body: body,
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.background,
      selectedItemColor: AppColors.activeIcon,
      unselectedItemColor: AppColors.inactiveIcon,
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == currentIndex) return;
        Navigator.pushReplacement(
          context,
          _noTransitionRoute(_screenForIndex(index)),
        );
      },
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.store_rounded), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard_rounded), label: 'Rewards'),
        BottomNavigationBarItem(
            icon: Icon(Icons.receipt_rounded), label: 'Orders'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded), label: 'Profile'),
      ],
    );
  }

  Widget _screenForIndex(int index) {
    switch (index) {
      case 0:
        return HomeScreen(viewModel: viewModel ?? HomeViewModel()..setProducts([]));
      case 1:
        return RewardsScreen(userProfile: userProfile);
      case 2:
        return OrdersScreen(userProfile: userProfile);
      case 3:
        return ProfileScreen(viewModel: viewModel!);
      default:
        return const SizedBox.shrink();
    }
  }

  Route _noTransitionRoute(Widget screen) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          child,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    );
  }
}
