import 'package:flutter/material.dart';
import 'package:the_code_cup/viewmodels/app_view_models.dart';
import 'package:the_code_cup/viewmodels/ui_models.dart';
import 'package:the_code_cup/views/cart_screen.dart';
import 'package:the_code_cup/views/details_screen.dart';
import 'package:the_code_cup/views/home_screen.dart';
import 'package:the_code_cup/views/order_success_screen.dart';
import 'package:the_code_cup/views/orders_screen.dart';
import 'package:the_code_cup/views/profile_screen.dart';
import 'package:the_code_cup/views/redeem_rewards_screen.dart';
import 'package:the_code_cup/views/rewards_screen.dart';
import 'package:the_code_cup/widgets/app_scope.dart';

/// Central navigation wiring. Screens only receive callbacks — they never
/// import sibling screens.
class AppNavigator {
  AppNavigator._();

  static AppViewModels _vms(BuildContext context) => AppScope.of(context);

  static Widget tab(BuildContext context, int index) {
    final vms = _vms(context);
    return switch (index) {
      0 => HomeScreen(
        viewModel: vms.home,
        onOpenCart: () => openCart(context),
        onOpenDetails: (id) => openDetails(context, id),
        onTabSelected: (i) => goTab(context, i),
      ),
      1 => RewardsScreen(
        viewModel: vms.rewards,
        onOpenRedeem: () => openRedeem(context),
        onTabSelected: (i) => goTab(context, i),
      ),
      2 => OrdersScreen(
        viewModel: vms.orders,
        onTabSelected: (i) => goTab(context, i),
      ),
      3 => ProfileScreen(
        viewModel: vms.profile,
        onTabSelected: (i) => goTab(context, i),
      ),
      _ => const SizedBox.shrink(),
    };
  }

  static void goTab(BuildContext context, int index) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            tab(context, index),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            child,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  static void openCart(BuildContext context) {
    final vms = _vms(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CartScreen(
          viewModel: vms.cart,
          onCheckoutSuccess: () => openOrderSuccess(context),
          onEditItem: (line) => openEditDetails(context, line),
        ),
      ),
    );
  }

  static void openEditDetails(BuildContext context, CartLineUi line) {
    final vms = _vms(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailsScreen(
          productId: line.productId,
          home: vms.home,
          cart: vms.cart,
          onOpenCart: () => openCart(context),
          groupIndex: line.index,
          initialSelections: line.selections,
          initialQuantity: line.quantity,
        ),
      ),
    );
  }

  static void openDetails(BuildContext context, String productId) {
    final vms = _vms(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailsScreen(
          productId: productId,
          home: vms.home,
          cart: vms.cart,
          onOpenCart: () => openCart(context),
        ),
      ),
    );
  }

  static void openOrderSuccess(BuildContext context) {
    final vms = _vms(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OrderSuccessScreen(
          viewModel: vms.orders,
          onTrackOrder: () => goTab(context, 2),
        ),
      ),
    );
  }

  static void openRedeem(BuildContext context) {
    final vms = _vms(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RedeemRewardsScreen(viewModel: vms.rewards),
      ),
    );
  }
}
