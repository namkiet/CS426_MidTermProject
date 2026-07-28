# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Run

```bash
# Run app
flutter run

# Run all tests
flutter test

# Run all unit tests
flutter test test/unit/

# Run all UI tests
flutter test test/ui/

# Run a single test file
flutter test test/ui/home_screen_test.dart

# Run a specific test by name
flutter test --name "shows user name"
```

## Project Structure

```
lib/
  main.dart                     — Entry point, wires up ViewModel + seed data
  constants/app_colors.dart     — Brand color palette
  data/seed_data.dart           — Initial product/user/loyalty data
  models/                       — Domain entities (no framework deps)
    product.dart, cart_item.dart, order.dart,
    loyalty_card.dart, reward_points.dart,
    transaction.dart, redeemable_item.dart,
    user_profile.dart
  services/
    local_storage.dart          — SharedPreferences wrapper: save/load user profile & stamp count
  viewmodels/home_viewmodel.dart — State holder for HomeScreen (ChangeNotifier)
  views/
    home_screen.dart            — Home screen with header, loyalty card, coffee grid, bottom nav
    profile_screen.dart         — Profile screen (name, email, phone, address, avatar)
    rewards_screen.dart         — Rewards placeholder
    orders_screen.dart          — Orders placeholder
    details_screen.dart         — Product details with customization & add-to-cart

test/
  unit/                         — Entity/logic unit tests (pure Dart, no widgets)
  ui/                           — Widget integration tests with flutter_test
```

## Architecture (MVVM)

- **Pattern** — Model-View-ViewModel: domain entities in `models/`, state holders (`ChangeNotifier`) in `viewmodels/`, consumer screens in `views/`.
- **No DI framework** — ViewModels are manually wired in `main.dart` and passed as constructor params.
- **ViewModels** use `ChangeNotifier` → consumed directly by `StatelessWidget` (no `ListenableBuilder`/`Consumer` yet).
- **Navigation** — raw `Navigator.push` from bottom nav `onTap`; no routing package.
- **Business logic** lives in model methods (e.g. `Order.calculatePointsEarned()`).
- **Pricing** is in VND, stored as `double` (basePrice) with customization deltas.
- **Seed data** loaded at startup; persisted values (profile, stamps) override defaults via `shared_preferences`.
- **Persistence** — `lib/services/local_storage.dart` wraps `SharedPreferences` for user profile (name, email, phone, address) and loyalty stamps. Loaded in `main.dart` before `runApp`; saved on profile edit.

## Key Conventions

- `ponytail:` comments mark intentional simplifications with a note on when to upgrade.
- Tests follow Arrange-Act-Assert with clear group/test naming.
- Entity constructors use `assert` for invariant validation (no exceptions).
- `withValues(alpha:)` for opacity (not `withOpacity`).
