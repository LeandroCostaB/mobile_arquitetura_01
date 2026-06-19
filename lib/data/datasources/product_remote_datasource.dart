import 'package:dio/dio.dart';
import 'package:product_app/data/models/product_model.dart';

class ProductRemoteDatasource {
  final Dio client;

  ProductRemoteDatasource(this.client);

  Future<List<ProductModel>> getProducts() async {
    final response = await client.get('https://dummyjson.com/products');
    final List data = response.data['products'];
    return data.map((json) => ProductModel.fromJson(json)).toList();
  }

  Future<ProductModel> getProductById(int id) async {
    final response = await client.get('https://dummyjson.com/products/$id');
    return ProductModel.fromJson(response.data);
  }

  Future<ProductModel> addProduct(ProductModel product) async {
    final response = await client.post(
      'https://dummyjson.com/products/add',
      data: product.toJson(),
    );
    return ProductModel.fromJson(response.data);
  }

  Future<ProductModel> updateProduct(ProductModel product) async {
    final response = await client.put(
      'https://dummyjson.com/products/${product.id}',
      data: product.toJson(),
    );
    return ProductModel.fromJson(response.data);
  }

  Future<void> deleteProduct(int id) async {
    await client.delete('https://dummyjson.com/products/$id');
  }
}
