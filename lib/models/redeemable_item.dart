class RedeemableItem {
  final String name;
  final int pointCost;
  final String? imageUrl;

  RedeemableItem({
    required this.name,
    required this.pointCost,
    this.imageUrl,
  }) : assert(pointCost > 0);

  Map<String, dynamic> toJson() => {
        'name': name,
        'pointCost': pointCost,
        'imageUrl': imageUrl,
      };

  factory RedeemableItem.fromJson(Map<String, dynamic> json) => RedeemableItem(
        name: json['name'] as String,
        pointCost: json['pointCost'] as int,
        imageUrl: json['imageUrl'] as String?,
      );
}
