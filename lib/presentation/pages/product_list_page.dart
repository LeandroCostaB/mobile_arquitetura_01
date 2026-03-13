import 'package:flutter/material.dart';
import '../viewmodels/product_viewmodel.dart';

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
      appBar: AppBar(title: const Text('Produtos')),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          if (widget.viewModel.isLoading) return const Center(child: CircularProgressIndicator());
          
          return ListView.builder(
            itemCount: widget.viewModel.products.length,
            itemBuilder: (context, index) {
              final product = widget.viewModel.products[index];
              return ListTile(
                leading: Image.network(product.image, width: 50),
                title: Text(product.title),
                subtitle: Text('R\$ ${product.price.toStringAsFixed(2)}'),
              );
            },
          );
        },
      ),
    );
  }
}