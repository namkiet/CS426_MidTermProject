import 'package:flutter/material.dart';
import 'package:the_code_cup/core/routes/app_navigator.dart';
import 'package:the_code_cup/presentation/viewmodels/app_view_models.dart';
import 'package:the_code_cup/presentation/viewmodels/ui_models.dart';
import 'package:the_code_cup/presentation/screens/cart_screen.dart';
import 'package:the_code_cup/presentation/screens/details_screen.dart';
import 'package:the_code_cup/presentation/screens/home_screen.dart';
import 'package:the_code_cup/presentation/screens/orders_screen.dart';
import 'package:the_code_cup/presentation/screens/profile_screen.dart';
import 'package:the_code_cup/presentation/screens/rewards_screen.dart';
import 'package:the_code_cup/presentation/widgets/app_scope.dart';

AppViewModels createTestApp() => AppViewModels.create();

Widget wrapWithApp(AppViewModels vms, Widget home) {
  return AppScope(
    vms: vms,
    child: MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: home,
    ),
  );
}

/// Full navigator wiring — use when a test needs real tab/stack navigation.
Widget wrapNavigated(AppViewModels vms, {int tab = 0}) {
  return AppScope(
    vms: vms,
    child: MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: Builder(builder: (context) => AppNavigator.tab(context, tab)),
    ),
  );
}

Widget testHome(AppViewModels app) => HomeScreen(
      viewModel: app.home,
      onOpenCart: () {},
      onOpenDetails: (_) {},
      onTabSelected: (_) {},
    );

Widget testRewards(AppViewModels app) => RewardsScreen(
      viewModel: app.rewards,
      onOpenRedeem: () {},
      onTabSelected: (_) {},
    );

Widget testOrders(AppViewModels app) => OrdersScreen(
      viewModel: app.orders,
      onTabSelected: (_) {},
    );

Widget testProfile(AppViewModels app) => ProfileScreen(
      viewModel: app.profile,
      onTabSelected: (_) {},
    );

Widget testCart(
  AppViewModels app, {
  VoidCallback? onCheckout,
  void Function(CartLineUi line)? onEditItem,
}) =>
    CartScreen(
      viewModel: app.cart,
      onCheckout: onCheckout ?? () {},
      onEditItem: onEditItem ?? (_) {},
    );

Widget testDetails(
  AppViewModels app,
  String productId, {
  VoidCallback? onOpenCart,
}) =>
    DetailsScreen(
      productId: productId,
      home: app.home,
      cart: app.cart,
      onOpenCart: onOpenCart ?? () {},
    );
