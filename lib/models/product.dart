class Product {
  final String id;
  final String name;
  final String? description;
  final double basePrice;
  final String? imageUrl;
  final Map<String, Map<String, double>> availableCustomizations;

  Product({
    String? id,
    required this.name,
    required this.basePrice,
    this.description,
    this.imageUrl,
    required this.availableCustomizations,
  })  : id = id ?? _generateId(name),
        assert(name.isNotEmpty),
        assert(basePrice > 0);

  static String _generateId(String name) =>
      '${name.toLowerCase().replaceAll(RegExp(r'\s+'), '-')}-${DateTime.now().millisecondsSinceEpoch}';

  double calculateUnitPrice([Map<String, String> selections = const {}]) {
    double total = basePrice;
    for (final entry in selections.entries) {
      total += availableCustomizations[entry.key]?[entry.value] ?? 0;
    }
    return total;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'basePrice': basePrice,
        'imageUrl': imageUrl,
        'availableCustomizations': availableCustomizations,
      };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as String,
        name: json['name'] as String,
        basePrice: (json['basePrice'] as num).toDouble(),
        description: json['description'] as String?,
        imageUrl: json['imageUrl'] as String?,
        availableCustomizations:
            (json['availableCustomizations'] as Map<String, dynamic>)
                .map((k, v) => MapEntry(
                      k,
                      (v as Map<String, dynamic>)
                          .map((k2, v2) => MapEntry(k2, (v2 as num).toDouble())),
                    )),
      );
}
