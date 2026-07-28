import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_code_cup/data/seed_data.dart';
import 'package:the_code_cup/models/cart_item.dart';
import 'package:the_code_cup/models/product.dart';
import 'package:the_code_cup/views/details_screen.dart';

void main() {
  late Product product;

  setUp(() {
    product = SeedData.products.first; // Espresso
  });

  /// Scrolls down until [finder] is visible.
  Future<void> scrollTo(WidgetTester tester, Finder finder) async {
    await tester.scrollUntilVisible(
      finder,
      200,
      scrollable: find.byType(Scrollable).first,
    );
  }

  Widget buildApp({ValueChanged<CartItem>? onAddToCart}) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: DetailsScreen(
        product: product,
        onAddToCart: onAddToCart ?? (_) {},
      ),
    );
  }

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

    testWidgets('shows base price', (tester) async {
      await tester.pumpWidget(buildApp());
      expect(find.textContaining('25.000'), findsAtLeastNWidgets(1));
    });

    testWidgets('shows product image', (tester) async {
      await tester.pumpWidget(buildApp());
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('shows back button', (tester) async {
      await tester.pumpWidget(buildApp());
      expect(find.byType(BackButton), findsOneWidget);
    });
  });

  group('DetailsScreen customization options', () {
    testWidgets('shows size options as selectable chips', (tester) async {
      await tester.pumpWidget(buildApp());
      expect(find.text('Small'), findsOneWidget);
      expect(find.textContaining('Large'), findsOneWidget);
    });

    testWidgets('shows shot options when product has them', (tester) async {
      await tester.pumpWidget(buildApp());
      await scrollTo(tester, find.textContaining('Single'));
      expect(find.textContaining('Single'), findsOneWidget);
      expect(find.textContaining('Double'), findsOneWidget);
    });

    testWidgets('shows ice options as selectable chips', (tester) async {
      await tester.pumpWidget(buildApp());
      await scrollTo(tester, find.text('Hot'));
      expect(find.text('Hot'), findsOneWidget);
      expect(find.text('Iced'), findsOneWidget);
    });

    testWidgets('first option in each group is selected by default',
        (tester) async {
      await tester.pumpWidget(buildApp());
      await scrollTo(tester, find.text('Hot'));
      final chips = find.byType(FilterChip);
      expect(chips, findsAtLeast(3));
    });

    testWidgets('changing size updates total price', (tester) async {
      await tester.pumpWidget(buildApp());
      expect(find.textContaining('25.000'), findsAtLeastNWidgets(1));
      await tester.tap(find.textContaining('Large'));
      await tester.pumpAndSettle();
      expect(find.textContaining('30.000'), findsAtLeastNWidgets(1));
    });

    testWidgets('changing shot updates total price', (tester) async {
      await tester.pumpWidget(buildApp());
      await scrollTo(tester, find.textContaining('Double'));
      await tester.tap(find.textContaining('Double'));
      await tester.pumpAndSettle();
      expect(find.textContaining('35.000'), findsAtLeastNWidgets(1));
    });

    testWidgets('changing ice does not change price (delta = 0)',
        (tester) async {
      await tester.pumpWidget(buildApp());
      await scrollTo(tester, find.text('Iced'));
      await tester.tap(find.text('Iced'));
      await tester.pumpAndSettle();
      expect(find.textContaining('25.000'), findsAtLeastNWidgets(1));
    });
  });

  group('DetailsScreen quantity', () {
    testWidgets('shows quantity selector with default quantity 1',
        (tester) async {
      await tester.pumpWidget(buildApp());
      await scrollTo(tester, find.text('1'));
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('increment button increases quantity', (tester) async {
      await tester.pumpWidget(buildApp());
      await scrollTo(tester, find.byIcon(Icons.add));
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('decrement button decreases quantity', (tester) async {
      await tester.pumpWidget(buildApp());
      await scrollTo(tester, find.byIcon(Icons.add));
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(find.text('2'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('quantity cannot go below 1', (tester) async {
      await tester.pumpWidget(buildApp());
      await scrollTo(tester, find.byIcon(Icons.remove));
      expect(find.text('1'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('changing quantity updates total price', (tester) async {
      await tester.pumpWidget(buildApp());
      await scrollTo(tester, find.byIcon(Icons.add));
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(find.textContaining('50.000'), findsAtLeastNWidgets(1));
    });
  });

  group('DetailsScreen add to cart', () {
    testWidgets('tapping Add to Cart button triggers callback',
        (tester) async {
      CartItem? captured;
      await tester.pumpWidget(buildApp(
        onAddToCart: (item) => captured = item,
      ));
      await tester.tap(find.textContaining('Add to cart'));
      await tester.pumpAndSettle();
      expect(captured, isNotNull);
      expect(captured!.product, product);
    });

    testWidgets('add to cart passes selected customizations',
        (tester) async {
      CartItem? captured;
      await tester.pumpWidget(buildApp(
        onAddToCart: (item) => captured = item,
      ));
      await tester.tap(find.textContaining('Large'));
      await tester.pumpAndSettle();
      await scrollTo(tester, find.textContaining('Double'));
      await tester.tap(find.textContaining('Double'));
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('Add to cart'));
      await tester.pumpAndSettle();
      expect(captured!.selectedCustomizations['size'], 'Large');
      expect(captured!.selectedCustomizations['shot'], 'Double');
    });

    testWidgets('add to cart passes current quantity', (tester) async {
      CartItem? captured;
      await tester.pumpWidget(buildApp(
        onAddToCart: (item) => captured = item,
      ));
      await scrollTo(tester, find.byIcon(Icons.add));
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('Add to cart'));
      await tester.pumpAndSettle();
      expect(captured!.quantity, 2);
    });
  });

  group('DetailsScreen cart preview', () {
    testWidgets('tapping cart icon shows bottom sheet', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.tap(find.textContaining('Add to cart'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
      await tester.pumpAndSettle();
      expect(find.text('Cart'), findsOneWidget);
    });
  });

  group('DetailsScreen navigation', () {
    testWidgets('back button pops the screen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailsScreen(product: product),
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
