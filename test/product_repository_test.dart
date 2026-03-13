import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:product_app/data/repositories/product_repository_impl.dart';
import 'package:product_app/domain/entities/product.dart';

import 'product_repository_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late ProductRepositoryImpl repository;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    repository = ProductRepositoryImpl(client: mockClient);
  });

  group('ProductRepository - Testes de API', () {

    test('Deve retornar uma lista de produtos quando a API responder 200', () async {
      when(mockClient.get(Uri.parse('https://fakestoreapi.com/products')))
          .thenAnswer((_) async => http.Response(
              '[{"id":1,"title":"Produto 1","price":29.9,"image":"url"}]', 200));

      final result = await repository.getProducts();

      expect(result, isA<List<Product>>());
      expect(result.first.title, 'Produto 1');
    });

    test('Deve lançar uma Exception quando a API responder erro 404', () async {
      when(mockClient.get(any))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(() => repository.getProducts(), throwsException);
    });

  });
}