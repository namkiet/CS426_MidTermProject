import 'package:flutter/foundation.dart';
import 'package:the_code_cup/domain/services/cart_service.dart';
import 'package:the_code_cup/data/repositories/cart_repository.dart';
import 'package:the_code_cup/data/repositories/reward_repository.dart';
import 'package:the_code_cup/data/repositories/profile_repository.dart';
import 'package:the_code_cup/data/repositories/catalog_repository.dart';
import 'package:the_code_cup/presentation/viewmodels/ui_models.dart';

class HomeViewModel extends ChangeNotifier {
  final CartRepository _cartRepo;
  final RewardRepository _rewardRepo;
  final ProfileRepository _profileRepo;
  final CatalogRepository _catalog;
  final CartService _cartService;

  HomeViewModel({
    required CartRepository cartRepo,
    required RewardRepository rewardRepo,
    required ProfileRepository profileRepo,
    CatalogRepository? catalog,
    CartService? cartService,
  })  : _cartRepo = cartRepo,
        _rewardRepo = rewardRepo,
        _profileRepo = profileRepo,
        _catalog = catalog ?? CatalogRepository(),
        _cartService = cartService ?? CartService() {
    _cartRepo.addListener(notifyListeners);
    _rewardRepo.addListener(notifyListeners);
    _profileRepo.addListener(notifyListeners);
  }

  @override
  void dispose() {
    _cartRepo.removeListener(notifyListeners);
    _rewardRepo.removeListener(notifyListeners);
    _profileRepo.removeListener(notifyListeners);
    super.dispose();
  }

  String get userName => _profileRepo.profile.name;

  String get userInitial => _profileRepo.profile.name.isNotEmpty
      ? _profileRepo.profile.name[0].toUpperCase()
      : '?';

  String? get avatarUrl => _profileRepo.profile.avatarUrl;

  LoyaltyCardUi get loyaltyCard {
    final n = _rewardRepo.loyaltyCard.stampCount;
    return LoyaltyCardUi(
      stampCount: n,
      countLabel: '$n / 8',
      subtitle: '${8 - n} more stamps to a free drink!',
      canReset: n >= 8,
    );
  }

  int get cartItemCount => _cartService.countDistinctItems(_cartRepo.items);

  List<ProductCardUi> get products => _catalog.products
      .map((p) => ProductCardUi(id: p.id, name: p.name, imageUrl: p.imageUrl))
      .toList();

  ProductDetailsUi? detailsFor(String productId) {
    final p = _catalog.productById(productId);
    if (p == null) return null;
    final defaults = <String, String>{};
    final groups = <CustomizationGroupUi>[];
    for (final entry in p.availableCustomizations.entries) {
      defaults[entry.key] = entry.value.keys.first;
      groups.add(
        CustomizationGroupUi(
          key: entry.key,
          title: entry.key[0].toUpperCase() + entry.key.substring(1),
          options: entry.value.entries
              .map(
                (o) => CustomizationOptionUi(
                  label: o.key,
                  chipLabel:
                      '${o.key}${o.value > 0 ? ' (+${money(o.value)})' : ''}',
                ),
              )
              .toList(),
        ),
      );
    }
    return ProductDetailsUi(
      id: p.id,
      name: p.name,
      description: p.description,
      basePriceLabel: money(p.basePrice),
      imageUrl: p.imageUrl,
      groups: groups,
      defaultSelections: defaults,
    );
  }

  String totalPriceLabel(
    String productId,
    Map<String, String> selections,
    int quantity,
  ) {
    final p = _catalog.productById(productId);
    if (p == null) return money(0);
    return money(_cartService.calculateUnitPrice(p, selections) * quantity);
  }
}
