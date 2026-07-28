class RedeemableItem {
  final String name;
  final int pointCost;
  final String? imageUrl;

  RedeemableItem({
    required this.name,
    required this.pointCost,
    this.imageUrl,
  }) : assert(pointCost > 0);
}
