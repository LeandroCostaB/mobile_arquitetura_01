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

  @override
  Future<List<Product>> getProducts() async {
    try {
      final models = await remote.getProducts();
      cache.save(models);
      return models
          .map((m) => Product(
                id: m.id,
                title: m.title,
                price: m.price,
                image: m.image,
                isFavorite: false,
              ))
          .toList();
    } catch (e) {
      final cached = cache.get();
      if (cached != null) {
        return cached
            .map((m) => Product(
                  id: m.id,
                  title: m.title,
                  price: m.price,
                  image: m.image,
                ))
            .toList();
      }
      throw Failure("Não foi possível carregar os produtos");
    }
  }

  @override
  Future<Product> addProduct(Product product) async {
    try {
      final model = ProductModel(
        id: product.id,
        title: product.title,
        price: product.price,
        image: product.image,
      );
      final resultModel = await remote.addProduct(model);
      return Product(
        id: resultModel.id,
        title: resultModel.title,
        price: resultModel.price,
        image: resultModel.image,
      );
    } catch (e) {
      throw Failure("Erro ao adicionar produto");
    }
  }

  @override
  Future<Product> updateProduct(Product product) async {
    try {
      final model = ProductModel(
        id: product.id,
        title: product.title,
        price: product.price,
        image: product.image,
      );
      final resultModel = await remote.updateProduct(model);
      return Product(
        id: resultModel.id,
        title: resultModel.title,
        price: resultModel.price,
        image: resultModel.image,
      );
    } catch (e) {
      throw Failure("Erro ao atualizar produto");
    }
  }

  @override
  Future<void> deleteProduct(int id) async {
    try {
      await remote.deleteProduct(id);
    } catch (e) {
      throw Failure("Erro ao excluir produto");
    }
  }
}