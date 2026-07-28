import 'package:flutter/foundation.dart';
import 'package:the_code_cup/models/product.dart';

class HomeViewModel extends ChangeNotifier {
  final List<Product> _products = [];

  List<Product> get products => List.unmodifiable(_products);

  void setProducts(List<Product> products) {
    _products.clear();
    _products.addAll(products);
    notifyListeners();
  }
}
