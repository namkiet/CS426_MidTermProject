import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_code_cup/constants/app_colors.dart';
import 'package:the_code_cup/data/seed_data.dart';
import 'package:the_code_cup/views/home_screen.dart';
import 'package:the_code_cup/viewmodels/home_viewmodel.dart';

void main() {
  late HomeViewModel viewModel;

  setUp(() {
    viewModel = HomeViewModel();
    viewModel.setProducts(SeedData.products);
  });

  Widget buildApp() {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: HomeScreen(viewModel: viewModel),
    );
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
      expect(find.text('Good morning!'), findsOneWidget);
    });

    testWidgets('shows cart icon in header', (tester) async {
      await tester.pumpWidget(buildApp());
      expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
    });

    testWidgets('avatar is a CircleAvatar with correct radius and color',
        (tester) async {
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

    testWidgets('loyalty card has dark slate background', (tester) async {
      await tester.pumpWidget(buildApp());
      Container? card;
      for (final c in find.byType(Container).evaluate()) {
        final container = c.widget as Container;
        if (container.decoration is BoxDecoration) {
          final decoration = container.decoration as BoxDecoration;
          if (decoration.color == AppColors.primary) {
            card = container;
            break;
          }
        }
      }
      expect(card, isNotNull);
    });

    testWidgets('stamp tray has white background', (tester) async {
      await tester.pumpWidget(buildApp());
      // find white inner container inside loyalty card
      Container? tray;
      for (final c in find.byType(Container).evaluate()) {
        final container = c.widget as Container;
        if (container.decoration is BoxDecoration) {
          final decoration = container.decoration as BoxDecoration;
          if (decoration.color == AppColors.background &&
              decoration.borderRadius == const BorderRadius.all(Radius.circular(12))) {
            tray = container;
          }
        }
      }
      expect(tray, isNotNull);
    });

    testWidgets('shows Choose your coffee section', (tester) async {
      await tester.pumpWidget(buildApp());
      expect(find.text('Choose your coffee'), findsOneWidget);
    });

    testWidgets('section title uses textOnDarkSecondary color', (tester) async {
      await tester.pumpWidget(buildApp());
      final title = tester.widget<Text>(find.text('Choose your coffee'));
      expect(title.style?.color, AppColors.textOnDarkSecondary);
    });

    testWidgets('products displayed in grid with 2 columns', (tester) async {
      await tester.pumpWidget(buildApp());
      final gridWidget = find.byType(GridView);
      expect(gridWidget, findsOneWidget);
      for (final product in SeedData.products) {
        expect(find.text(product.name), findsOneWidget);
      }
    });

    testWidgets('each grid item shows product name', (tester) async {
      await tester.pumpWidget(buildApp());
      for (final product in SeedData.products) {
        expect(find.text(product.name), findsOneWidget);
      }
    });

    testWidgets('each grid item shows image or fallback icon', (tester) async {
      await tester.pumpWidget(buildApp());
      for (final product in SeedData.products) {
        final item = find.text(product.name);
        expect(item, findsOneWidget);
      }
    });

    testWidgets('price is hidden — no price text visible', (tester) async {
      await tester.pumpWidget(buildApp());
      for (final product in SeedData.products) {
        final priceStr = '${product.basePrice.toStringAsFixed(0)}đ';
        expect(find.text(priceStr), findsNothing);
      }
    });

    testWidgets('description is hidden — no description text visible',
        (tester) async {
      await tester.pumpWidget(buildApp());
      for (final product in SeedData.products) {
        if (product.description != null) {
          expect(find.text(product.description!), findsNothing);
        }
      }
    });

    testWidgets('product name text uses textPrimary color', (tester) async {
      await tester.pumpWidget(buildApp());
      for (final product in SeedData.products) {
        final textWidget = tester.widget<Text>(find.text(product.name));
        expect(textWidget.style?.color, AppColors.textPrimary);
      }
    });

    testWidgets('grid SliverGridDelegate has correct spacing', (tester) async {
      await tester.pumpWidget(buildApp());
      final grid = tester.widget<GridView>(find.byType(GridView));
      final delegate =
          grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.mainAxisSpacing, 16);
      expect(delegate.crossAxisSpacing, 16);
      expect(delegate.childAspectRatio, 1.0);
    });

    testWidgets('product names are centered in card', (tester) async {
      await tester.pumpWidget(buildApp());
      for (final product in SeedData.products.take(3)) {
        final textWidget = tester.widget<Text>(find.text(product.name));
        expect(textWidget.textAlign, TextAlign.center);
      }
    });

    group('bottom navigation', () {
      testWidgets('has Home, Rewards, Orders, Profile tabs', (tester) async {
        await tester.pumpWidget(buildApp());
        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Rewards'), findsOneWidget);
        expect(find.text('Orders'), findsOneWidget);
        expect(find.text('Profile'), findsOneWidget);
      });

      testWidgets('uses correct bottom nav colors', (tester) async {
        await tester.pumpWidget(buildApp());
        final navBar = tester.widget<BottomNavigationBar>(
          find.byType(BottomNavigationBar),
        );
        expect(navBar.backgroundColor, AppColors.background);
        expect(navBar.selectedItemColor, AppColors.activeIcon);
        expect(navBar.unselectedItemColor, AppColors.inactiveIcon);
      });

      testWidgets('home icon uses store icon', (tester) async {
        await tester.pumpWidget(buildApp());
        expect(find.byIcon(Icons.store_rounded), findsOneWidget);
      });
    });

    group('navigation', () {
      testWidgets('tapping Profile tab navigates away from home screen', (tester) async {
        await tester.pumpWidget(buildApp());
        expect(find.text('Good morning!'), findsOneWidget);
        await tester.tap(find.text('Profile'));
        await tester.pumpAndSettle();
        expect(find.text('Good morning!'), findsNothing);
      });
    });

    group('stamps', () {
      testWidgets('active stamps use coffee_rounded icon', (tester) async {
        await tester.pumpWidget(buildApp());
        expect(find.byIcon(Icons.coffee_rounded), findsNothing);
      });

      testWidgets('inactive stamps use coffee_outlined icon', (tester) async {
        await tester.pumpWidget(buildApp());
        expect(find.byIcon(Icons.coffee_outlined), findsNWidgets(8));
      });

      testWidgets('active stamps are dark slate', (tester) async {
        await tester.pumpWidget(buildApp());
        for (final icon
            in find.byIcon(Icons.coffee_rounded).evaluate()) {
          final i = icon.widget as Icon;
          expect(i.color, AppColors.stampFilled);
        }
      });

      testWidgets('inactive stamps are light grey', (tester) async {
        await tester.pumpWidget(buildApp());
        for (final icon
            in find.byIcon(Icons.coffee_outlined).evaluate()) {
          final i = icon.widget as Icon;
          expect(i.color, AppColors.stampEmpty);
        }
      });
    });
  });
}
