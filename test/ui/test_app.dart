import 'package:flutter/material.dart';
import 'package:the_code_cup/navigation/app_navigator.dart';
import 'package:the_code_cup/viewmodels/app_view_models.dart';
import 'package:the_code_cup/viewmodels/ui_models.dart';
import 'package:the_code_cup/views/cart_screen.dart';
import 'package:the_code_cup/views/details_screen.dart';
import 'package:the_code_cup/views/home_screen.dart';
import 'package:the_code_cup/views/orders_screen.dart';
import 'package:the_code_cup/views/profile_screen.dart';
import 'package:the_code_cup/views/rewards_screen.dart';
import 'package:the_code_cup/widgets/app_scope.dart';

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
  VoidCallback? onCheckoutSuccess,
  void Function(CartLineUi line)? onEditItem,
}) =>
    CartScreen(
      viewModel: app.cart,
      onCheckoutSuccess: onCheckoutSuccess ?? () {},
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
