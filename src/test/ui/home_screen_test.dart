import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_code_cup/core/constants/app_colors.dart';
import 'package:the_code_cup/domain/models/cart_item.dart';
import 'package:the_code_cup/data/datasources/seed_data.dart';
import 'package:the_code_cup/presentation/viewmodels/app_view_models.dart';
import 'package:the_code_cup/presentation/screens/details_screen.dart';
import 'test_app.dart';

void main() {
  late AppViewModels app;

  setUp(() {
    app = createTestApp();
  });

  Widget buildApp() => wrapWithApp(app, testHome(app));

  Widget buildNavigated() => wrapNavigated(app);

  String expectedGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning!';
    if (hour < 18) return 'Good afternoon!';
    return 'Good evening!';
  }

  group('HomeScreen UI', () {
    testWidgets('shows user name in header', (tester) async {
      await tester.pumpWidget(buildApp());
      expect(find.text('Nam Kiet'), findsOneWidget);
    });

    testWidgets('shows user avatar initial', (tester) async {
      await tester.pumpWidget(buildApp());
      expect(find.text('N'), findsOneWidget);
    });

    testWidgets('shows greeting text', (tester) async {
      await tester.pumpWidget(buildApp());
      expect(find.text(expectedGreeting()), findsOneWidget);
    });

    testWidgets('shows cart icon in header', (tester) async {
      await tester.pumpWidget(buildApp());
      expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
    });

    testWidgets('shows badge with cart count when items added', (tester) async {
      await tester.pumpWidget(buildApp());
      expect(find.text('1'), findsNothing);

      app.cartRepo.items.add(CartItem(
        product: SeedData.products[0],
        selectedCustomizations: {},
        quantity: 1,
      ));
      app.cartRepo.notifyListeners();
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('avatar is a CircleAvatar with correct radius and color', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
      expect(avatar.radius, 20);
      expect(avatar.backgroundColor, AppColors.surface);
    });

    testWidgets('name text color is textPrimary', (tester) async {
      await tester.pumpWidget(buildApp());
      final nameText = tester.widget<Text>(find.text('Nam Kiet'));
      expect(nameText.style?.color, AppColors.textPrimary);
    });

    testWidgets('shows Loyalty card section', (tester) async {
      await tester.pumpWidget(buildApp());
      expect(find.text('Loyalty card'), findsOneWidget);
      expect(find.text('0 / 8'), findsOneWidget);
      expect(find.textContaining('more stamps'), findsOneWidget);
    });

    testWidgets('shows Choose your coffee section', (tester) async {
      await tester.pumpWidget(buildApp());
      expect(find.text('Choose your coffee'), findsOneWidget);
    });

    testWidgets('products displayed in grid with 2 columns', (tester) async {
      await tester.pumpWidget(buildApp());
      expect(find.byType(GridView), findsOneWidget);
      for (final product in SeedData.products) {
        expect(find.text(product.name), findsOneWidget);
      }
    });

    testWidgets('price is hidden — no price text visible', (tester) async {
      await tester.pumpWidget(buildApp());
      for (final product in SeedData.products) {
        final priceStr = '${product.basePrice.toStringAsFixed(0)}đ';
        expect(find.text(priceStr), findsNothing);
      }
    });

    testWidgets('bottom nav has Home, Rewards, Orders, Profile tabs', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Rewards'), findsOneWidget);
      expect(find.text('Orders'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('tapping Profile tab navigates away from home screen', (
      tester,
    ) async {
      await tester.pumpWidget(buildNavigated());
      expect(find.text(expectedGreeting()), findsOneWidget);
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();
      expect(find.text(expectedGreeting()), findsNothing);
    });

    testWidgets('tapping a product navigates to details screen', (
      tester,
    ) async {
      await tester.pumpWidget(buildNavigated());
      await tester.scrollUntilVisible(
        find.text('Espresso'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Espresso'));
      await tester.pumpAndSettle();
      expect(find.byType(DetailsScreen), findsOneWidget);
    });

    testWidgets('inactive stamps use coffee_outlined icon', (tester) async {
      await tester.pumpWidget(buildApp());
      expect(find.byIcon(Icons.coffee_outlined), findsNWidgets(8));
    });
  });
}