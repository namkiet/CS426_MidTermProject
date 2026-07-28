import 'package:the_code_cup/viewmodels/repo_view_model.dart';
import 'package:the_code_cup/viewmodels/ui_models.dart';

class HomeViewModel extends RepoViewModel {
  HomeViewModel(super.repo);

  String get userName => repo.userProfile.name;

  String get userInitial => repo.userProfile.name.isNotEmpty
      ? repo.userProfile.name[0].toUpperCase()
      : '?';

  LoyaltyCardUi get loyaltyCard {
    final n = repo.loyaltyCard.stampCount;
    return LoyaltyCardUi(
      stampCount: n,
      countLabel: '$n / 8',
      subtitle: '${8 - n} more stamps to a free drink!',
      canReset: n >= 8,
    );
  }

  List<ProductCardUi> get products => repo.products
      .map((p) => ProductCardUi(id: p.id, name: p.name, imageUrl: p.imageUrl))
      .toList();

  ProductDetailsUi? detailsFor(String productId) {
    final p = repo.productById(productId);
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
    final p = repo.productById(productId);
    if (p == null) return money(0);
    return money(p.calculateUnitPrice(selections) * quantity);
  }
}
