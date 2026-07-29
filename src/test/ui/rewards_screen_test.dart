import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:the_code_cup/presentation/viewmodels/app_view_models.dart';
import 'package:the_code_cup/presentation/screens/redeem_rewards_screen.dart';
import 'test_app.dart';

void main() {
  late AppViewModels app;

  setUp(() async {
    Hive.init(
      '${Directory.systemTemp.path}/rewards_test_${DateTime.now().microsecondsSinceEpoch}',
    );
    await Hive.openBox('the_code_cup');
    app = createTestApp();
  });

  Widget buildApp() => wrapWithApp(app, testRewards(app));

  group('RewardsScreen', () {
    testWidgets('shows bottom nav with 4 tabs', (tester) async {
      await tester.pumpWidget(buildApp());
      final navBar = find.byType(BottomNavigationBar);
      expect(navBar, findsOneWidget);
      final items = (tester.widget(navBar) as BottomNavigationBar).items;
      expect(items[0].label, 'Home');
      expect(items[1].label, 'Rewards');
      expect(items[2].label, 'Orders');
      expect(items[3].label, 'Profile');
    });

    testWidgets('shows points balance', (tester) async {
      await tester.pumpWidget(buildApp());
      expect(find.text('0'), findsOneWidget);
      expect(find.text('Points Balance'), findsOneWidget);
    });

    testWidgets('shows Redeem button', (tester) async {
      await tester.pumpWidget(buildApp());
      expect(find.text('Redeem'), findsOneWidget);
    });

    testWidgets('shows loyalty card', (tester) async {
      await tester.pumpWidget(buildApp());
      expect(find.text('Loyalty Card'), findsOneWidget);
    });

    testWidgets('shows empty transactions state', (tester) async {
      await tester.pumpWidget(buildApp());
      expect(find.text('No transactions yet'), findsOneWidget);
    });
  });

  group('RedeemRewardsScreen', () {
    testWidgets('tapping a redeemable item shows confirmation dialog', (
      tester,
    ) async {
      app.rewardRepo.rewardPoints.balance = 500;

      await tester.pumpWidget(
        wrapWithApp(app, RedeemRewardsScreen(viewModel: app.rewards)),
      );

      await tester.tap(find.text('Free Espresso'));
      await tester.pumpAndSettle();

      expect(find.text('Confirm Redemption'), findsOneWidget);
    });
  });
}
