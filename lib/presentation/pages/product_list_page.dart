import 'package:flutter/material.dart';
import '../viewmodels/product_viewmodel.dart';
import '../viewmodels/product_state.dart';

class ProductListPage extends StatefulWidget {
  final ProductViewModel viewModel;

  const ProductListPage({super.key, required this.viewModel});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {

  @override
  void initState() {
    super.initState();
    widget.viewModel.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loja de Produtos'),
      ),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {

          final state = widget.viewModel.state;

          // Loading
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Error
          if (state.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi_off, size: 64, color: Colors.red),
                  const SizedBox(height: 10),
                  Text(state.error!),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: widget.viewModel.fetchProducts,
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          // Success
          return RefreshIndicator(
            onRefresh: widget.viewModel.fetchProducts,
            child: ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {

                final product = state.products[index];

                return ListTile(
                  leading: Image.network(
                    product.image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(product.title),
                  subtitle: Text(
                    'R\$ ${product.price.toStringAsFixed(2)}',
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}