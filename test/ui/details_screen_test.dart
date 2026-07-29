import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:the_code_cup/data/seed_data.dart';
import 'package:the_code_cup/viewmodels/app_view_models.dart';
import 'package:the_code_cup/navigation/app_navigator.dart';
import 'package:the_code_cup/views/details_screen.dart';
import 'test_app.dart';

void main() {
  late AppViewModels app;
  late String productId;

  setUp(() async {
    Hive.init('${Directory.systemTemp.path}/details_test_${DateTime.now().microsecondsSinceEpoch}');
    await Hive.openBox('the_code_cup');
    app = createTestApp();
    productId = SeedData.products.first.id;
  });

  Future<void> scrollTo(WidgetTester tester, Finder finder) async {
    await tester.scrollUntilVisible(
      finder,
      200,
      scrollable: find.byType(Scrollable).first,
    );
  }

  Widget buildApp() => wrapWithApp(
    app,
    Builder(
      builder: (context) => testDetails(
        app,
        productId,
        onOpenCart: () => AppNavigator.openCart(context),
      ),
    ),
  );

  group('DetailsScreen layout', () {
    testWidgets('shows product name', (tester) async {
      await tester.pumpWidget(buildApp());
      expect(find.text('Espresso'), findsOneWidget);
    });

    testWidgets('shows product description', (tester) async {
      await tester.pumpWidget(buildApp());
      expect(
        find.text('Strong and bold classic espresso shot'),
        findsOneWidget,
      );
    });

    testWidgets('shows Add to cart button', (tester) async {
      await tester.pumpWidget(buildApp());
      expect(find.textContaining('Add to cart'), findsOneWidget);
    });
  });

  group('DetailsScreen interactions', () {
    testWidgets('add to cart shows centered notification but stays on details screen', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.tap(find.textContaining('Add to cart'));
      await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 200)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.textContaining('Added to cart'), findsOneWidget);
      // Advance fake clock to fire the auto-dismiss timer
      await tester.pump(const Duration(seconds: 2));
      await tester.pump();
      // No navigation on add-to-cart; details screen stays visible.
      expect(find.byType(DetailsScreen), findsOneWidget);
      expect(find.text('My Cart'), findsNothing);
    });

    testWidgets('add to cart passes current quantity', (tester) async {
      await tester.pumpWidget(buildApp());
      await scrollTo(tester, find.byIcon(Icons.add));
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('Add to cart'));
      await tester.pumpAndSettle();
      expect(app.cart.lines.first.quantityLabel, 'x2');
    });
  });

  group('DetailsScreen cart icon', () {
    testWidgets('tapping cart icon navigates to cart screen', (tester) async {
      app.cart.addToCart(productId, {}, 1);
      await tester.pumpWidget(buildApp());
      await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
      await tester.pumpAndSettle();
      expect(find.text('My Cart'), findsOneWidget);
    });
  });

  group('DetailsScreen navigation', () {
    testWidgets('back button pops the screen', (tester) async {
      await tester.pumpWidget(
        wrapWithApp(
          app,
          Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => testDetails(app, productId),
                  ),
                ),
                child: const Text('Go'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Go'));
      await tester.pumpAndSettle();
      expect(find.byType(DetailsScreen), findsOneWidget);
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.byType(DetailsScreen), findsNothing);
    });
  });
}
