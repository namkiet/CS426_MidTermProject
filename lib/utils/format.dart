String formatPrice(double price) {
  return '${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}đ';
}

String formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}
