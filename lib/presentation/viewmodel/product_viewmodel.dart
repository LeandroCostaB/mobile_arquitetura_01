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
      _state = _state.copyWith(
        isLoading: false,
        products: products,
      );
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
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
      _state = _state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    _state = _state.copyWith(isLoading: true, error: null);
    notifyListeners();
    
    try {
      final updatedProduct = await repository.updateProduct(product);
      final updatedProducts = _state.products.map((p) {
        return p.id == updatedProduct.id ? updatedProduct : p;
      }).toList();
      
      _state = _state.copyWith(
        isLoading: false,
        products: updatedProducts,
      );
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
    notifyListeners();
  }

  Future<void> deleteProduct(int id) async {
    _state = _state.copyWith(isLoading: true, error: null);
    notifyListeners();
    
    try {
      await repository.deleteProduct(id);
      final updatedProducts = _state.products.where((p) => p.id != id).toList();
      
      _state = _state.copyWith(
        isLoading: false,
        products: updatedProducts,
      );
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
    notifyListeners();
  }

  void toggleFavorite(int productId) {
    final updatedProducts = _state.products.map((product) {
      if (product.id == productId) {
        return product.copyWith(isFavorite: !product.isFavorite);
      }
      return product;
    }).toList();
    
    _state = _state.copyWith(products: updatedProducts);
    notifyListeners();
  }
}