import 'package:product_app/core/errors/failure.dart';
import 'package:product_app/data/datasources/product_cache_datasource.dart';
import 'package:product_app/data/datasources/product_remote_datasource.dart';
import 'package:product_app/data/models/product_model.dart';
import 'package:product_app/domain/entities/product.dart';
import 'package:product_app/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource remote;
  final ProductCacheDatasource cache;

  ProductRepositoryImpl(this.remote, this.cache);

  Product _fromModel(ProductModel m, {bool isFavorite = false}) {
    return Product(
      id: m.id,
      title: m.title,
      description: m.description,
      category: m.category,
      price: m.price,
      rating: m.rating,
      stock: m.stock,
      thumbnail: m.thumbnail,
      isFavorite: isFavorite,
    );
  }

  ProductModel _toModel(Product p) {
    return ProductModel(
      id: p.id,
      title: p.title,
      description: p.description,
      category: p.category,
      price: p.price,
      rating: p.rating,
      stock: p.stock,
      thumbnail: p.thumbnail,
    );
  }

  @override
  Future<List<Product>> getProducts() async {
    try {
      final models = await remote.getProducts();
      cache.save(models);
      return models.map((m) => _fromModel(m)).toList();
    } catch (e) {
      final cached = cache.get();
      if (cached != null) {
        return cached.map((m) => _fromModel(m)).toList();
      }
      throw Failure('Não foi possível carregar os produtos');
    }
  }

  @override
  Future<Product> getProductById(int id) async {
    try {
      final model = await remote.getProductById(id);
      return _fromModel(model);
    } catch (e) {
      throw Failure('Não foi possível carregar o produto');
    }
  }

  @override
  Future<Product> addProduct(Product product) async {
    try {
      final resultModel = await remote.addProduct(_toModel(product));
      return _fromModel(resultModel);
    } catch (e) {
      throw Failure('Erro ao adicionar produto');
    }
  }

  @override
  Future<Product> updateProduct(Product product) async {
    try {
      final resultModel = await remote.updateProduct(_toModel(product));
      return _fromModel(resultModel);
    } catch (e) {
      throw Failure('Erro ao atualizar produto');
    }
  }

  @override
  Future<void> deleteProduct(int id) async {
    try {
      await remote.deleteProduct(id);
    } catch (e) {
      throw Failure('Erro ao excluir produto');
    }
  }
}
