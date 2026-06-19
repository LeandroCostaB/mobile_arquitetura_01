import 'package:flutter/material.dart';
import 'package:product_app/domain/entities/product.dart';
import 'package:product_app/domain/repositories/product_repository.dart';
import 'package:provider/provider.dart';
import 'package:product_app/presentation/viewmodel/product_viewmodel.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late Future<Product> _productFuture;

  @override
  void initState() {
    super.initState();
    // Item 18/19: GET /products/{id} explícito
    final repository =
        context.read<ProductViewModel>().repository;
    _productFuture = repository.getProductById(widget.product.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Navigator.pop explícito
        ),
      ),
      body: FutureBuilder<Product>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            // Fallback para os dados já carregados em caso de erro
            return _buildContent(widget.product);
          }

          final product = snapshot.data ?? widget.product;
          return _buildContent(product);
        },
      ),
    );
  }

  Widget _buildContent(Product product) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            product.thumbnail,
            width: double.infinity,
            height: 280,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const SizedBox(
              height: 280,
              child: Center(child: Icon(Icons.error, size: 100)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'R\$ ${product.price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text('${product.rating}'),
                    const SizedBox(width: 16),
                    const Icon(Icons.inventory_2_outlined, size: 18),
                    const SizedBox(width: 4),
                    Text('Estoque: ${product.stock}'),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Categoria: ${product.category}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Descrição',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.description,
                  style: const TextStyle(fontSize: 15, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
