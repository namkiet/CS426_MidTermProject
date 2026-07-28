class RedeemableItem {
  final String id;
  final String name;
  final int pointCost;
  final String? imageUrl;

  RedeemableItem({
    String? id,
    required this.name,
    required this.pointCost,
    this.imageUrl,
  }) : id = id ?? _generateId(name),
       assert(name.isNotEmpty),
       assert(pointCost > 0);

  static String _generateId(String name) =>
      name.toLowerCase().replaceAll(RegExp(r'\s+'), '-');

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'pointCost': pointCost,
    'imageUrl': imageUrl,
  };

  factory RedeemableItem.fromJson(Map<String, dynamic> json) => RedeemableItem(
    id: json['id'] as String?,
    name: json['name'] as String,
    pointCost: json['pointCost'] as int,
    imageUrl: json['imageUrl'] as String?,
  );
}
