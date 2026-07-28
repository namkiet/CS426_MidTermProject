import 'package:flutter/material.dart';
import 'package:the_code_cup/constants/app_colors.dart';

/// Shared bottom tab bar. Navigation is injected via [onTabSelected].
class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.background,
      selectedItemColor: AppColors.activeIcon,
      unselectedItemColor: AppColors.inactiveIcon,
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == currentIndex) return;
        onTabSelected(index);
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.store_rounded), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.card_giftcard_rounded),
          label: 'Rewards',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_rounded),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_rounded),
          label: 'Profile',
        ),
      ],
    );
  }
}

/// Shared app bar styling. Screens pass it into Scaffold.appBar.
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool centerTitle;
  final List<Widget>? actions;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final bool implyLeading;

  const AppAppBar({
    super.key,
    this.title,
    this.centerTitle = true,
    this.actions,
    this.leading,
    this.bottom,
    this.implyLeading = true,
  });

  @override
  Size get preferredSize => Size.fromHeight(
    kToolbarHeight + (bottom?.preferredSize.height ?? 0),
  );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title == null
          ? null
          : Text(
              title!,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
      centerTitle: centerTitle,
      backgroundColor: AppColors.background,
      elevation: 0,
      actions: actions,
      leading: leading,
      automaticallyImplyLeading: implyLeading,
      bottom: bottom,
    );
  }
}

/// Slot / template composition for screens.
///
/// Each screen fills three slots (`appBar`, `navigationBar`, `body`);
/// this template assembles them into one [Scaffold].
class ScreenTemplate extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? navigationBar;
  final Widget body;

  const ScreenTemplate({
    super.key,
    this.appBar,
    this.navigationBar,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: appBar,
      bottomNavigationBar: navigationBar,
      body: body,
    );
  }
}
