import 'package:flutter/material.dart';
import 'package:product_app/domain/entities/product.dart';
import 'package:product_app/presentation/viewmodel/product_viewmodel.dart';
import 'package:provider/provider.dart';

class ProductFormPage extends StatefulWidget {
  final Product? product;

  const ProductFormPage({super.key, this.product});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _priceController;
  late TextEditingController _imageController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.product?.title ?? "");
    _priceController = TextEditingController(
      text: widget.product?.price.toString() ?? "",
    );
    _imageController = TextEditingController(text: widget.product?.image ?? "");
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final viewModel = context.read<ProductViewModel>();
      
      final product = Product(
        id: widget.product?.id ?? 0,
        title: _titleController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        image: _imageController.text,
      );

      if (widget.product == null) {
        viewModel.addProduct(product).then((_) {
          if (mounted) Navigator.pop(context);
        });
      } else {
        viewModel.updateProduct(product).then((_) {
          if (mounted) Navigator.pop(context);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit Product" : "Add Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a title";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a price";
                  }
                  if (double.tryParse(value) == null) {
                    return "Please enter a valid number";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: "Image URL"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter an image URL";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _save,
                child: Text(isEditing ? "Update" : "Create"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}