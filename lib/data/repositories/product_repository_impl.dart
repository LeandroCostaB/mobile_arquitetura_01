import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/product.dart';
import '../../domain/repositories/i_product_repository.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements IProductRepository {
  final http.Client client;

  // Se não passarmos um client, ele usa o padrão do pacote http
  ProductRepositoryImpl({http.Client? client}) : client = client ?? http.Client();

  @override
  Future<List<Product>> getProducts() async {
    final response = await client.get(Uri.parse('https://fakestoreapi.com/products'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => ProductModel.fromJson(item)).toList();
    } else {
      throw Exception('Erro ao carregar produtos');
    }
  }
}