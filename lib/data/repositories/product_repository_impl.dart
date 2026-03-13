import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/product.dart';
import '../../domain/repositories/i_product_repository.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements IProductRepository {
  final http.Client client;
  
  static List<Product> _cache = []; 

  ProductRepositoryImpl({http.Client? client}) : client = client ?? http.Client();

  @override
  Future<List<Product>> getProducts() async {
    try {
      final response = await client.get(Uri.parse('https://fakestoreapi.com/products'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final products = data.map((item) => ProductModel.fromJson(item)).toList();
        
        _cache = products; 
        return products;
      } else {
        throw Exception();
      }
    } catch (e) {
      
      if (_cache.isNotEmpty) {
        return _cache;
      }
      throw Exception('Falha na rede e sem cache disponível.');
    }
  }
}