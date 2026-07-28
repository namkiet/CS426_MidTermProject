class Product {
  final String name;
  final String? description;
  final double basePrice;
  final String? imageUrl;
  final Map<String, Map<String, double>> availableCustomizations;

  Product({
    required this.name,
    required this.basePrice,
    this.description,
    this.imageUrl,
    required this.availableCustomizations,
  }) : assert(name.isNotEmpty),
       assert(basePrice > 0);

  double calculateUnitPrice([Map<String, String> selections = const {}]) {
    double total = basePrice;
    for (final entry in selections.entries) {
      total += availableCustomizations[entry.key]?[entry.value] ?? 0;
    }
    return total;
  }
}
