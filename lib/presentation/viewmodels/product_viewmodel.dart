import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/i_product_repository.dart';

class ProductViewModel extends ChangeNotifier {
  final IProductRepository repository;
  List<Product> products = [];
  bool isLoading = false;

  ProductViewModel(this.repository);

  Future<void> fetchProducts() async {
    isLoading = true;
    notifyListeners();
    try {
      products = await repository.getProducts();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}