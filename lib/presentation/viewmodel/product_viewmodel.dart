import 'package:flutter/material.dart';
import 'package:product_app/domain/entities/product.dart';
import 'package:product_app/domain/repositories/product_repository.dart';
import 'package:product_app/presentation/viewmodel/product_state.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductRepository repository;
  ProductState _state = const ProductState();

  ProductState get state => _state;

  ProductViewModel(this.repository);

  Future<void> loadProducts() async {
    _state = _state.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      final products = await repository.getProducts();
      _state = _state.copyWith(isLoading: false, products: products);
    } catch (e) {
      _state = _state.copyWith(isLoading: false, error: e.toString());
    }
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    _state = _state.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      final newProduct = await repository.addProduct(product);
      _state = _state.copyWith(
        isLoading: false,
        products: [..._state.products, newProduct],
      );
    } catch (e) {
      _state = _state.copyWith(isLoading: false, error: e.toString());
    }
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    _state = _state.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      final updated = await repository.updateProduct(product);
      final updatedList = _state.products.map((p) {
        return p.id == updated.id ? updated : p;
      }).toList();
      _state = _state.copyWith(isLoading: false, products: updatedList);
    } catch (e) {
      _state = _state.copyWith(isLoading: false, error: e.toString());
    }
    notifyListeners();
  }

  Future<void> deleteProduct(int id) async {
    _state = _state.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      await repository.deleteProduct(id);
      final updatedList = _state.products.where((p) => p.id != id).toList();
      _state = _state.copyWith(isLoading: false, products: updatedList);
    } catch (e) {
      _state = _state.copyWith(isLoading: false, error: e.toString());
    }
    notifyListeners();
  }

  void toggleFavorite(int productId) {
    final updatedList = _state.products.map((p) {
      if (p.id == productId) {
        return p.copyWith(isFavorite: !p.isFavorite);
      }
      return p;
    }).toList();

    _state = _state.copyWith(products: updatedList);
    notifyListeners();
  }
}
