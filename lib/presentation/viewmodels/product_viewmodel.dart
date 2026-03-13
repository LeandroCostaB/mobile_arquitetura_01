import 'package:flutter/material.dart';
import '../../domain/repositories/i_product_repository.dart';
import 'product_state.dart';

class ProductViewModel extends ChangeNotifier {
  final IProductRepository repository;

  ProductState state = const ProductState();

  ProductViewModel(this.repository);

  Future<void> fetchProducts() async {
    state = state.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      final products = await repository.getProducts();

      state = state.copyWith(
        isLoading: false,
        products: products,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }

    notifyListeners();
  }
}