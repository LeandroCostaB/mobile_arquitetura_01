
import 'package:dio/dio.dart';
import 'package:product_app/data/models/product_model.dart';

class ProductRemoteDatasource {
  final Dio client;
  
  ProductRemoteDatasource ( this .client );
  
  Future<List<ProductModel>> getProducts () async {
    final response = await client.get("https://fakestoreapi.com/products");
  
    final List data = response.data;
  
    return data
      .map((json) => ProductModel.fromJson(json))
      .toList();
  }

  Future<ProductModel> addProduct(ProductModel product) async {
    final response = await client.post(
      "https://fakestoreapi.com/products",
      data: product.toJson(),
    );
    return ProductModel.fromJson(response.data);
  }

  Future<ProductModel> updateProduct(ProductModel product) async {
    final response = await client.put(
      "https://fakestoreapi.com/products/${product.id}",
      data: product.toJson(),
    );
    return ProductModel.fromJson(response.data);
  }

  Future<void> deleteProduct(int id) async {
    await client.delete("https://fakestoreapi.com/products/$id");
  }
}